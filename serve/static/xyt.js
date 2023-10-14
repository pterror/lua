const af = (async () => {}).constructor,
	S = Symbol(),
	P = Symbol(),
	T = Symbol(),
	R = Symbol(),
	C = Symbol(),
	E = console.error,
	Od = Object.defineProperties,
	Op = Object.getOwnPropertyDescriptors,
	X = {};
X.prefix = document.body?.getAttribute("xyt-prefix") ?? "x-";
export default X;
/**@type{(()=>void)|undefined}*/ X.currentEffect = undefined;
/**@type{(expression:string)=>(scope:unknown)=>Promise<unknown>}*/
X.evaluator = (e) => af("$", "with($)return " + e.trim());
X.defaultDirective = "bind";
/**@typedef{HTMLElement&{[S]:any,[P]:Comment|undefined,[T]:Element|undefined,[C]:string|undefined}}XytElement*/
/**@typedef{(this:typeof X,element:XytElement,value:any,name:string,originalAttributeName:string,queueTransform:(elements:Element[])=>void) => void}D*/
/**@type Record<string,D>*/
const d = (X.directives = {});
X.baseScope = {};
/**@type{{}|undefined}*/ X.tick = undefined;
/**@type{(element?:?XytElement|string)=>Promise<void>}*/
X.mount = async function (e) {
	const t = this;
	if (typeof (e ??= /**@type{XytElement}*/ (document.body)) == "string")
		e = /**@type{XytElement}*/ (document.querySelector(e));
	e[S] = { __proto__: this.baseScope };
	const p = e.getAttribute("xyt-prefix") ?? this.prefix;
	// TODO: .modifiers?
	const re = new RegExp("^(?:" + p + "([^:]+))?(?::(.*))?$");
	/**@type{(c:XytElement,s?:unknown)=>Promise<void>}*/
	const x = async (c, s) => {
		//@ts-expect-error
		s = c[S] ??= s ?? { __proto__: c.parentElement?.[S] ?? this.baseScope };
		for (const a_ of c.getAttributeNames()) {
			let [, a, n] = a_.match(re) ?? [];
			if (!a && !n) continue;
			a ??= this.defaultDirective;
			const d = this.directives[a];
			if (!d) continue;
			try {
				const f = this.evaluator(/**@type{string}*/ (c.getAttribute(a_)));
				let v;
				if (/**@type{any}*/ (d).raw) v = f.bind(undefined, s);
				else {
					// TODO: reactive x-for will be difficult.
					t.currentEffect = async () =>
						d.call(this, c, await f(s), n, a_, () => {});
					const p = f(s);
					t.currentEffect = undefined;
					v = await p;
				}
				/**@type{Element[]|undefined}*/ let q;
				d.call(this, c, v, n, a_, (e) => {
					(q ??= []).push(...e);
				});
				if (q) for (const e of q) await x(/**@type{XytElement}*/ (e));
			} catch (e) {
				E("Error processing element:", c);
				E(e);
			}
			if (!c.isConnected) break;
		}
		if (c.isConnected)
			for (const c2 of c.children) x(/**@type{XytElement}*/ (c2));
	};
	x(e);
};
/**@type{<T extends object>(this:typeof X,value:T,deep?:boolean,parentDependency?:never)=>T}*/
X.reactive = function (v, d = true, p) {
	if (/**@type{any}*/ (v)[R]) return v;
	const t = this;
	const r = Od(
		v,
		Object.fromEntries(
			Object.entries(v).map(([k, v]) => {
				/**@type{Set<()=>void>}*/ const D = new Set();
				p && D.add(p);
				const U = () => {
					for (const d of D) d();
				};
				if (d && typeof v === "object")
					v = this.reactive(v, d, /**@type{never}*/ (U));
				let u = this.tick;
				return [
					k,
					{
						get: () => {
							this.currentEffect && D.add(this.currentEffect);
							return v;
						},
						set: (v_) => {
							if (!Object.is(v, v_)) {
								v = v_;
								if (!this.tick) {
									u = t.tick = {};
									U();
									t.tick = void 0;
								} else if (u !== this.tick) {
									u = this.tick;
									U();
								}
							}
						},
					},
				];
			})
		)
	);
	/**@type{any}*/ (r)[R] = true;
	return r;
};
d.init = /**@type{D}*/ (_, v) => {
	v();
};
d.effect = /**@type{D}*/ () => {}; // Only run the effect
d.text = /**@type{D}*/ (e, v) => {
	e.innerText = v;
};
d.html = /**@type{D}*/ (e, v) => {
	e.innerHTML = v;
};
d.class = /**@type{D}*/ (e, v) => {
	e[C] ??= e.classList.value;
	if (Array.isArray(v)) v = v.join(" ");
	if (typeof v === "string") e.classList.value = e[C] + (v ? " " + v : "");
	else
		for (const k in v)
			if (v[k]) e.classList.add(k);
			else e.classList.remove(k);
};
d.style = /**@type{D}*/ (e, v) => {
	Object.assign(e.style, v);
};
d.bind = /**@type{D}*/ (e, v, n) => {
	if (n != null) e.setAttribute(n, v);
	else for (const k in v) e.setAttribute(k, v[k]);
};
d.on = /**@type{D}*/ (e, v, n) => {
	if (n != null) e.addEventListener(n, v);
	else for (const k in v) e.addEventListener(k, v[k]);
};
d.show = /**@type{D}*/ (e, v) => {
	e.style.display = v ? "" : "none";
};
d.if = /**@type{D}*/ (e, v) => {
	if (!v && e.isConnected)
		e.replaceWith((e[P] ??= document.createComment("if")));
	if (v && e[P]?.isConnected) e[P].replaceWith(e);
};
d.for = /**@type{D}*/ (e, v, _, a_, q) => {
	let t = (e[T] ??= (() => {
		const t = /**@type{Element}*/ (e.cloneNode(true));
		t.removeAttribute(a_);
		return t;
	})());
	//@ts-expect-error
	const ps = e.parentElement?.[S] ?? bS;
	const c = Array.from(v, (data) => {
		const e2 = /**@type{Element}*/ (t.cloneNode(true));
		//@ts-expect-error
		e2[S] = Od({ __proto__: ps, data }, Op(data));
		return e2;
	});
	e.replaceWith(...c);
	q(c);
};
d.data = /**@type{D}*/ function (e, v) {
	Od(e[S], Op((e[S].data = this.reactive(v))));
};
/**@type{any}*/ (d.on).raw = /**@type{any}*/ (d.init).raw = true;
const root = /**@type{XytElement?}*/ (
	document.querySelector("[" + X.prefix + "app]")
);
root && X.mount(root);
