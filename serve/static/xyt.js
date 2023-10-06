const af = (async () => {}).constructor;
/**@type{Record<string,(scope:unknown)=>Promise<unknown>>}*/
const fs = {};
/**@type{(expression:string)=>(scope:unknown)=>Promise<unknown>}*/
const fn = (e) => (fs[e] ??= af("$", "with($)return " + e.trim() + ""));
function xyt() {} // for expando
xyt.prefix = document.body?.getAttribute("xyt-prefix") ?? "x-";
/**@type{Function|undefined}*/ xyt.currentEffect = undefined;
xyt.evaluator = fn;
xyt.defaultDirective = "bind";
export default xyt;
const S = Symbol("xyt-scope");
/**@typedef{HTMLElement&{[S]:any,[P]:Comment|undefined}}XytElement*/
/**@typedef{(this:typeof xyt,element:XytElement,value:any,name:string,originalAttributeName:string,queueTransform:(elements:Element[])=>void) => void}D*/
/**@type Record<string,D&{raw:boolean|undefined}>*/
xyt._directives = {};
const baseScope = {};
/**@type{(element?:?XytElement|string)=>Promise<void>}*/
xyt.mount = async function (e) {
	const t = this;
	if (typeof (e ??= /**@type{XytElement}*/ (document.body)) == "string")
		e = /**@type{XytElement}*/ (document.querySelector(e));
	e[S] = Object.create(baseScope);
	const p = e.getAttribute("xyt-prefix") ?? this.prefix;
	// TODO: .modifiers?
	const re = new RegExp("^(?:" + p + "([^:]+))?(?::(.*))?$");
	/**@type{(c:Element,s?:unknown)=>Promise<void>}*/
	const x = async (c, s) => {
		//@ts-expect-error
		s = c[S] ??= s ?? Object.create(c.parentElement?.[S] ?? baseScope);
		for (const a_ of c.getAttributeNames()) {
			let [, a, n] = a_.match(re) ?? [];
			if (!a && !n) continue;
			a ??= this.defaultDirective;
			const d = this._directives[a];
			if (!d) continue;
			// TODO: run things in parallel? or make it reactive
			try {
				const f = this.evaluator(/**@type{string}*/ (c.getAttribute(a_)));
				let v;
				if (d.raw) {
					v = () => f(s);
				} else {
					t.currentEffect = async () =>
						d.call(
							this,
							/**@type{XytElement}*/ (c),
							await f(s),
							n,
							a_,
							// TODO: reactive x-for will be difficult.
							(e) => {}
						);
					const p = f(s);
					t.currentEffect = undefined;
					v = await p;
				}
				/**@type{Element[]|undefined}*/ let q;
				d.call(this, /**@type{XytElement}*/ (c), v, n, a_, (e) =>
					(q ??= []).push(...e)
				);
				if (q) for (const e of q) await x(e);
			} catch (e) {
				console.error("Error processing element:", c);
				console.error(e);
			}
			if (!c.isConnected) break;
		}
		if (c.isConnected) for (const c2 of c.children) x(c2);
	};
	x(e);
};
/**@type{(name:string,func:D,raw?:boolean)=>void}*/
xyt.directive = function (n, f, r) {
	// @ts-expect-error
	r && (f.raw = r);
	// @ts-expect-error
	this._directives[n] = f;
};
xyt.tickInProgress = false;
xyt.tick = {};
/**@type{<T extends object>(this:typeof xyt,value:T)=>T}*/
xyt.reactive = function (v) {
	const t = this;
	return /**@type{any}*/ (
		Od(
			v,
			Object.fromEntries(
				Object.entries(v).map(([k, v]) => {
					let u = this.tick;
					/**@type{Set<Function>}*/ const D = new Set();
					return [
						k,
						/**@type{PropertyDescriptor}*/ ({
							get: () => {
								this.currentEffect && D.add(this.currentEffect);
								return v;
							},
							set: (v_) => {
								if (!Object.is(v, v_)) {
									v = v_;
									let s = false;
									if (!t.tickInProgress) {
										s = t.tickInProgress = true;
										t.tick = {};
									} else if (u === this.tick) return;
									u = this.tick;
									for (const d of D) d();
									s && (t.tickInProgress = false);
								}
							},
						}),
					];
				})
			)
		)
	);
};
const d = xyt.directive.bind(xyt);
d("text", (e, v) => (e.innerText = v));
d("html", (e, v) => (e.innerHTML = v));
d("class", (e, v) => {
	if (typeof v === "string") e.classList.add(...v.split(/\s+/));
	else if (typeof v === "object")
		for (const k in v) if (v[k]) e.classList.add(k);
});
d("bind", (e, v, n) => {
	if (n != null) e.setAttribute(n, v);
	else for (const k in v) e.setAttribute(k, v[k]);
});
d(
	"on",
	(e, v, n) => {
		if (n != null) e.addEventListener(n, v);
		else for (const k in v) e.addEventListener(k, v[k]);
	},
	true
);
const P = Symbol("xyt-placeholder");
d("if", function (e, v) {
	if (!v && e.isConnected)
		e.replaceWith((e[P] ??= document.createComment(this.prefix + "if")));
	if (v && e[P]?.isConnected) e[P].replaceWith(e);
});
const Od = Object.defineProperties;
d("for", (e, v, _, a_, q) => {
	const t = /**@type{Element}*/ (e.cloneNode(true));
	t.removeAttribute(a_);
	//@ts-expect-error
	const ps = e.parentElement?.[S] ?? baseScope;
	const c = Array.from(v, (data) => {
		const e2 = /**@type{Element}*/ (t.cloneNode(true));
		//@ts-expect-error
		e2[S] = Od(
			Object.assign(Object.create(ps), { data }),
			Object.getOwnPropertyDescriptors(data)
		);
		return e2;
	});
	e.replaceWith(...c);
	q(c);
});
d("data", function (e, v) {
	Od(e[S], Object.getOwnPropertyDescriptors((e[S].data = this.reactive(v))));
});
const root = /**@type{XytElement?}*/ (
	document.querySelector("[" + xyt.prefix + "app]")
);
root && xyt.mount(root);
