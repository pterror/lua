// TODO: fix `x-for`, array reactivity, conditional reactivity, reactivity GC (stress test and check for leaks)
"use strict";
const Function = (() => {}).constructor,
	AsyncFunction = (async () => {}).constructor,
	DataSym = Symbol(),
	PlaceholderSym = Symbol(),
	TemplateSym = Symbol(),
	ClassSym = Symbol(),
	ChildMapSym = Symbol(),
	ModelSym = Symbol(),
	unreactiveValues = new WeakMap(),
	reactiveMaps = new WeakMap(),
	consoleError = console.error,
	emptyObject = Object.freeze({}),
	Xyt = {},
	$ = {};
//@ts-expect-error
window.$ = $;
$.parent = "parentElement";
$.data = DataSym;
Xyt.prefix =
	new URLSearchParams(import.meta.url.match(/#(.+)/)?.[1]).get("prefix") ??
	"x-";
export default Xyt;
/**@type{(()=>void)|undefined}*/ Xyt.currentEffect = undefined;
/**@type{(expression:string,args?:string)=>(element:XytElement,scope:unknown)=>unknown}*/
Xyt.evaluator = (expression) =>
	(/\bawait\b/.test(expression) ? AsyncFunction : Function)(
		"$el,$data",
		"with($data)return " + expression
	);
Xyt.defaultDirective = "bind";
/**@typedef{HTMLElement&{[DataSym]:any,[PlaceholderSym]:Comment|undefined,[TemplateSym]:Element|undefined,[ClassSym]:string|undefined,[ModelSym]:true|undefined,[ChildMapSym]:Map<unknown,XytElement[]>|undefined}}XytElement*/
/**@typedef{(this:typeof Xyt,element:XytElement,value:any,name:string|undefined,originalAttributeName:string,queueTransform:(elements:Element[])=>void,stop:()=>void) => void}XytDirective*/
/**@type Record<string,XytDirective>*/
const directives = (Xyt.directives = {});
/**@type{{}|undefined}*/ Xyt.tick = undefined;
/**@type{(element?:?XytElement|string)=>Promise<void>}*/
Xyt.mount = async function (element) {
	const xyt = this;
	if (typeof (element ??= /**@type{XytElement}*/ (document.body)) == "string")
		element = /**@type{XytElement}*/ (document.querySelector(element));
	const prefix = this.prefix;
	// TODO: .modifiers?
	const attributeRegex = new RegExp("^(?:" + prefix + "([^:]+))?(?::(.*))?$");
	/**@type{(child:XytElement)=>Promise<void>}*/
	const processAttributes = async (child) => {
		//@ts-expect-error
		child[DataSym] ??= child.parentElement?.[DataSym] ?? emptyObject;
		let stopped = false;
		for (const rawAttribute of child.getAttributeNames()) {
			let [, attribute, name] = rawAttribute.match(attributeRegex) ?? [];
			if (!attribute && !name) continue;
			attribute ??= this.defaultDirective;
			const directive = this.directives[attribute];
			if (!directive) {
				console.warn("xyt: Unknown directive:", attribute);
				continue;
			}
			try {
				const callback = this.evaluator(
					/**@type{string}*/ (child.getAttribute(rawAttribute))
				);
				let value;
				if (/**@type{any}*/ (directive).raw)
					value = () => callback(child, child[DataSym]);
				else if (/**@type{any}*/ (directive).rw) {
					let write = this.evaluator(
						"$value=>" + child.getAttribute(rawAttribute) + "=$value"
					);
					const rwCallbacks = () => [
						callback(child, child[DataSym]),
						// @ts-expect-error
						(value) => write(child, child[DataSym])(value),
					];
					xyt.currentEffect = async () =>
						directive.call(
							this,
							child,
							await Promise.all(rwCallbacks()),
							name,
							rawAttribute,
							() => {},
							() => {}
						);
					const maybePromise = rwCallbacks();
					xyt.currentEffect = undefined;
					value =
						maybePromise[0] instanceof Promise
							? await Promise.all(maybePromise)
							: maybePromise;
				} else if (/**@type{any}*/ (directive).parent) {
					// TODO: reactive x-for will be difficult.
					xyt.currentEffect = async () =>
						directive.call(
							this,
							child,
							await callback(
								child,
								//@ts-expect-error
								child.parentElement?.[DataSym] ?? emptyObject
							),
							name,
							rawAttribute,
							() => {},
							() => {}
						);
					const maybePromise = callback(child, child[DataSym]);
					xyt.currentEffect = undefined;
					value =
						maybePromise instanceof Promise ? await maybePromise : maybePromise;
				} else {
					// TODO: reactive x-for will be difficult.
					xyt.currentEffect = async () =>
						directive.call(
							this,
							child,
							await callback(child, child[DataSym]),
							name,
							rawAttribute,
							() => {},
							() => {}
						);
					const maybePromise = callback(child, child[DataSym]);
					xyt.currentEffect = undefined;
					value =
						maybePromise instanceof Promise ? await maybePromise : maybePromise;
				}
				/**@type{Element[]|undefined}*/ let queue;
				directive.call(
					this,
					child,
					value,
					name,
					rawAttribute,
					(e) => {
						(queue ??= []).push(...e);
					},
					() => {
						stopped = true;
					}
				);
				if (queue)
					for (const element of queue)
						processAttributes(/**@type{XytElement}*/ (element));
			} catch (error) {
				consoleError(
					"xyt: Error processing element:",
					child,
					rawAttribute,
					child.getAttribute(rawAttribute)
				);
				consoleError(error);
			}
			if (!child.isConnected || stopped) break;
		}
		if (child.isConnected && !stopped)
			for (const children of child.children)
				processAttributes(/**@type{XytElement}*/ (children));
	};
	processAttributes(element);
};
/**@type{any}*/ const aH = Object.create(null);
// see https://github.com/vuejs/core/blob/c568778ea3265d8e57f788b00864c9509bf88a4e/packages/reactivity/src/baseHandlers.ts#L53
["includes", "indexOf", "lastIndexOf"].forEach((arrayMethod) => {
	/**@type{(tr:(k:string)=>void,...a:any[])=>any}*/
	aH[arrayMethod] = function (track, ...args) {
		const rawArray = unreactiveValues.get(this) ?? this;
		for (let i = 0, l = this.length; i < l; i++) track(i + "");
		const result = rawArray[arrayMethod](...args);
		if (result === -1 || result === false)
			return rawArray[arrayMethod](
				...args.map((a) => unreactiveValues.get(a) ?? a)
			);
		else return result;
	};
});
["push", "pop", "shift", "unshift", "splice"].forEach((arrayMethod) => {
	/**@type{(tr:(k:string)=>void,...a:any[])=>any}*/
	aH[arrayMethod] = function (_track, ...args) {
		const effect = Xyt.currentEffect;
		Xyt.currentEffect = undefined;
		const result = (unreactiveValues.get(this) ?? this)[arrayMethod].apply(
			this,
			args
		);
		Xyt.currentEffect = effect;
		return result;
	};
});
/**@type{<T extends object>(this:typeof Xyt,value:T,parent?:any,oldValue?:T,deep?:boolean,parentDependency?:never)=>T}*/
Xyt.reactive = function (
	value,
	parent,
	oldValue,
	deep = true,
	parentDependency
) {
	if (
		typeof value !== "object" ||
		value === null ||
		unreactiveValues.has(value)
	)
		return value;
	const xyt = this,
		/**@type{{ticks:Map<string|symbol,{}>,dependencies:Map<string|symbol,Set<()=>void>>,reactiveValues:Map<string|symbol,unknown>}}*/ maps =
			(oldValue && reactiveMaps.get(oldValue)) ?? {
				ticks: new Map(),
				dependencies: new Map(),
				reactiveValues: new Map(),
			},
		{
			ticks: keyTicks,
			dependencies: keyDependencies,
			reactiveValues: keyReactiveValues,
		} = maps,
		/**@type{Set<PropertyKey>}*/ trackedKeys = new Set();
	console.log("rx", value, oldValue, maps);
	/** @type {Set<()=>void>|undefined} */
	let objectWideEffects;
	if (Array.isArray(value)) {
		const set = (objectWideEffects = new Set());
		["filter", "map", "forEach"].forEach((key) =>
			keyDependencies.set(key, set)
		);
	}
	/**@type{(k:string|symbol)=>void}*/
	const runEffects = (key) => {
		const effects = keyDependencies.get(key);
		if (effects) for (const effect of effects) effect();
		if (objectWideEffects && objectWideEffects !== effects)
			for (const effect of objectWideEffects) effect();
	};
	/**@type{(key:string|symbol)=>void}*/
	const track = (key) => {
		if (xyt.currentEffect && key) {
			let dependencies = keyDependencies.get(key);
			if (!dependencies)
				keyDependencies.set(
					key,
					(dependencies = new Set(
						parentDependency ? [parentDependency] : undefined
					))
				);
			dependencies.add(xyt.currentEffect);
		}
	};
	/**@type{(k:string|symbol)=>void}*/
	const runTick = (k) => {
		if (!xyt.tick) {
			keyTicks.set(k, (xyt.tick = {}));
			runEffects(k);
			xyt.tick = undefined;
		} else if (keyTicks.get(k) !== xyt.tick) {
			keyTicks.set(k, xyt.tick);
			runEffects(k);
		}
	};
	const reactiveProxy = new Proxy(value, {
		get: (target, key) => {
			if (!(key in target)) return parent?.[key];
			// @ts-expect-error
			if (key === Symbol.unscopables) return target[key];
			track(key);
			const keyValue = Reflect.get(target, key);
			if (deep && typeof keyValue === "object" && keyValue) {
				let reactiveKeyValue = keyReactiveValues.get(key);
				console.log("bruh", key, keyValue, trackedKeys.has(key));
				if (!trackedKeys.has(key)) {
					trackedKeys.add(key);
					keyReactiveValues.set(
						key,
						(reactiveKeyValue = xyt.reactive(
							keyValue,
							parent,
							// @ts-expect-error
							reactiveKeyValue,
							deep,
							/**@type{never}*/ (() => runEffects(key))
						))
					);
				}
				return reactiveKeyValue;
			} else return keyValue;
		},
		set: (target, key, value) => {
			if (!(key in target)) {
				if (parent && key in parent) parent[key] = value;
				return !!parent;
			}
			if (!Object.is(Reflect.get(target, key), value)) {
				const R = Reflect.set(target, key, value);
				runTick(key);
				return R;
			}
			return true;
		},
		deleteProperty: (target, key) => {
			if (!(key in target)) {
				delete parent?.[key];
				return parent != null;
			}
			runTick(key);
			keyTicks.delete(key);
			keyDependencies.delete(key);
			keyReactiveValues.delete(key);
			return Reflect.deleteProperty(target, key);
		},
		has(target, key) {
			return Reflect.has(target, key) || (parent != null && key in parent);
		},
	});
	unreactiveValues.set(reactiveProxy, value);
	reactiveMaps.set(reactiveProxy, maps);
	return reactiveProxy;
};
directives.app = () => {};
directives.init = /**@type{XytDirective}*/ (element, value) => {
	value();
};
directives.effect = () => {}; // only run the effect
directives.text = /**@type{XytDirective}*/ (element, value) => {
	element.innerText = value;
};
directives.html = /**@type{XytDirective}*/ (element, value) => {
	element.innerHTML = value;
};
directives.class = /**@type{XytDirective}*/ (element, value) => {
	element[ClassSym] ??= element.classList.value;
	if (Array.isArray(value)) value = value.join(" ");
	if (typeof value === "string")
		element.classList.value = element[ClassSym] + (value ? " " + value : "");
	else
		for (const k in value)
			if (value[k]) element.classList.add(k);
			else element.classList.remove(k);
};
directives.style = /**@type{XytDirective}*/ (element, value) => {
	Object.assign(element.style, value);
};
directives.bind = /**@type{XytDirective}*/ (element, value, name) => {
	if (name != null) element.setAttribute(name, value);
	else for (const k in value) element.setAttribute(k, value[k]);
};
directives.on = /**@type{XytDirective}*/ (element, value, name) => {
	if (name != null) element.addEventListener(name, value);
	else for (const k in value) element.addEventListener(k, value[k]);
};
directives.show = /**@type{XytDirective}*/ (element, value) => {
	element.style.display = value ? "" : "none";
};
directives.ref = /**@type{XytDirective}*/ (element, { 1: write }) => {
	write(element);
};
directives.data = /**@type{XytDirective}*/ function (element, value) {
	element[DataSym] = this.reactive(
		value,
		//@ts-expect-error
		element.parentElement?.[DataSym],
		element[DataSym]
	);
};
directives.model = /**@type{XytDirective}*/ (
	element,
	{ 0: read, 1: write }
) => {
	/**@type{any}*/ (element).value = read;
	if (!element[ModelSym]) {
		element[ModelSym] = true;
		element.addEventListener("change", () =>
			write(/**@type{any}*/ (element).value)
		);
	}
};
//TODO:
directives.component = /**@type{XytDirective}*/ function (
	_element,
	value,
	_name,
	_attribute,
	_enqueue,
	stopProcessing
) {
	stopProcessing();
	customElements.define(
		this.prefix + value,
		{ [value]: class extends HTMLElement {} }[value]
	);
};
directives.if = /**@type{XytDirective}*/ (element, value) => {
	if (!value && element.isConnected)
		element.replaceWith(
			(element[PlaceholderSym] ??= document.createComment("if"))
		);
	if (value && element[PlaceholderSym]?.isConnected)
		element[PlaceholderSym].replaceWith(element);
};
directives.for = /**@type{XytDirective}*/ function (
	element,
	values,
	_name,
	attribute,
	enqueue
) {
	console.log("for", values);
	const template = (element[TemplateSym] ??= (() => {
		const template = /**@type{Element}*/ (element.cloneNode(true));
		template.removeAttribute(attribute);
		return template;
	})());
	const oldChildMap = element[ChildMapSym];
	/**@type{Map<unknown,XytElement[]>}*/ const newChildMap = new Map();
	/**@type{XytElement[]}*/ const newChildren = [];
	for (const value of values) {
		let childrenForValue = newChildMap.get(value);
		if (!childrenForValue) newChildMap.set(value, (childrenForValue = []));
		let child = oldChildMap?.get(value)?.[childrenForValue.length];
		if (!child) {
			newChildren.push(
				(child = /**@type{XytElement}*/ (
					/**@type{any}*/ (
						Object.assign(template.cloneNode(true), {
							//@ts-expect-error
							[DataSym]: this.reactive(value, element.parentElement?.[DataSym]),
						})
					)
				))
			);
		}
		childrenForValue.push(child);
	}
	element.replaceWith(...newChildren);
	enqueue(newChildren);
};
// FIXME: make less ad-hoc; pass event to event handler
/**@type{any}*/ (directives.app).raw =
	/**@type{any}*/ (directives.on).raw =
	/**@type{any}*/ (directives.init).raw =
	/**@type{any}*/ (directives.data).parent =
	/**@type{any}*/ (directives.ref).rw =
	/**@type{any}*/ (directives.model).rw =
		true;
const root = /**@type{XytElement?}*/ (
	document.querySelector("[" + Xyt.prefix + "app]")
);
root && Xyt.mount(root);
