const f = (() => {}).constructor,
	af = (async () => {}).constructor,
	S = Symbol(),
	P = Symbol(),
	T = Symbol(),
	C = Symbol(),
	M = Symbol(),
	R = new WeakSet(),
	E = console.error,
	Z = Object.freeze({}),
	X = {};
X.prefix = document.body?.getAttribute("xyt-prefix") ?? "x-";
export default X;
/**@type{(()=>void)|undefined}*/ X.currentEffect = undefined;
/**@type{(expression:string,args?:string)=>(scope:unknown)=>unknown}*/
X.evaluator = (e) =>
	(/\bawait\b/.test(e) ? af : f)("$data", "with($data)return " + e);
X.defaultDirective = "bind";
/**@typedef{HTMLElement&{[S]:any,[P]:Comment|undefined,[T]:Element|undefined,[C]:string|undefined,[M]:true|undefined}}XytElement*/
/**@typedef{(this:typeof X,element:XytElement,value:any,name:string,originalAttributeName:string,queueTransform:(elements:Element[])=>void) => void}D*/
/**@type Record<string,D>*/
const d = (X.directives = {});
/**@type{{}|undefined}*/ X.tick = undefined;
/**@type{(element?:?XytElement|string)=>Promise<void>}*/
X.mount = async function (e) {
	const t = this;
	if (typeof (e ??= /**@type{XytElement}*/ (document.body)) == "string")
		e = /**@type{XytElement}*/ (document.querySelector(e));
	const p = e.getAttribute("xyt-prefix") ?? this.prefix;
	// TODO: .modifiers?
	const re = new RegExp("^(?:" + p + "([^:]+))?(?::(.*))?$");
	/**@type{(c:XytElement,s?:unknown)=>Promise<void>}*/
	const x = async (c, s) => {
		//@ts-expect-error
		c[S] ??= c.parentElement?.[S] ?? Z;
		for (const a_ of c.getAttributeNames()) {
			let [, a, n] = a_.match(re) ?? [];
			if (!a && !n) continue;
			a ??= this.defaultDirective;
			const d = this.directives[a];
			if (!d) continue;
			try {
				const f = this.evaluator(/**@type{string}*/ (c.getAttribute(a_)));
				let v;
				if (/**@type{any}*/ (d).raw) v = () => f(c[S]);
				else if (/**@type{any}*/ (d).rw) {
					let w = this.evaluator("$value=>" + c.getAttribute(a_) + "=$value");
					// @ts-expect-error
					const V = () => [f(c[S]), (v) => w(c[S])(v)];
					t.currentEffect = async () =>
						d.call(this, c, await Promise.all(V()), n, a_, () => {});
					const p = V();
					t.currentEffect = undefined;
					v = p[0] instanceof Promise ? await Promise.all(p) : p;
				} else if (/**@type{any}*/ (d).parent) {
					// TODO: reactive x-for will be difficult.
					t.currentEffect = async () =>
						d.call(
							this,
							c,
							//@ts-expect-error
							await f(c.parentElement?.[S] ?? Z),
							n,
							a_,
							() => {}
						);
					const p = f(c[S]);
					t.currentEffect = undefined;
					v = p instanceof Promise ? await p : p;
				} else {
					// TODO: reactive x-for will be difficult.
					t.currentEffect = async () =>
						d.call(this, c, await f(c[S]), n, a_, () => {});
					const p = f(c[S]);
					t.currentEffect = undefined;
					v = p instanceof Promise ? await p : p;
				}
				/**@type{Element[]|undefined}*/ let q;
				d.call(this, c, v, n, a_, (e) => {
					(q ??= []).push(...e);
				});
				if (q) for (const e of q) x(/**@type{XytElement}*/ (e));
			} catch (e) {
				E("Error processing element:", c, a_, c.getAttribute(a_));
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
	if (typeof v !== "object" || v === null || R.has(v)) return v;
	const s = this,
		/**@type{Map<string|symbol,{}>}*/ u = new Map(),
		/**@type{Map<string|symbol,Set<()=>void>>}*/ m = new Map(),
		/**@type{Map<string|symbol,unknown>}*/ x = new Map();
	/**@type{(k:string|symbol)=>void}*/
	const U = (k) => {
		const D = m.get(k);
		if (D) for (const d of D) d();
	};
	const r = new Proxy(v, {
		get: (t, k) => {
			if (s.currentEffect && k !== Symbol.unscopables) {
				let M = m.get(k);
				if (!M) m.set(k, (M = p ? new Set([p]) : new Set()));
				M.add(s.currentEffect);
			}
			const R = Reflect.get(t, k);
			if (d && typeof R === "object" && R !== null) {
				let r2 = x.get(k);
				if (!r2)
					x.set(k, (r2 = s.reactive(R, d, /**@type{never}*/ (() => U(k)))));
				return r2;
			} else return R;
		},
		set: (t, k, v) => {
			if (!Object.is(Reflect.get(t, k), v)) {
				const R = Reflect.set(t, k, v);
				if (!s.tick) {
					u.set(k, (s.tick = {}));
					U(k);
					s.tick = void 0;
				} else if (u.get(k) !== s.tick) {
					u.set(k, s.tick);
					U(k);
				}
				return R;
			}
			return true;
		},
		deleteProperty: (t, k) => {
			u.delete(k);
			m.delete(k);
			x.delete(k);
			return Reflect.deleteProperty(t, k);
		},
	});
	R.add(r);
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
d.ref = /**@type{D}*/ (e, { 1: w }) => {
	w(e);
};
d.data = /**@type{D}*/ function (e, v) {
	e[S] = this.reactive(v);
};
d.model = /**@type{D}*/ function (e, { 0: r, 1: w }) {
	/**@type{any}*/ (e).value = r;
	if (!e[M]) {
		e[M] = true;
		e.addEventListener("keyup", () => w(/**@type{any}*/ (e).value));
	}
};
d.if = /**@type{D}*/ (e, v) => {
	if (!v && e.isConnected)
		e.replaceWith((e[P] ??= document.createComment("if")));
	if (v && e[P]?.isConnected) e[P].replaceWith(e);
};
d.for = /**@type{D}*/ function (e, v, _, a_, q) {
	let t = (e[T] ??= (() => {
		const t = /**@type{Element}*/ (e.cloneNode(true));
		t.removeAttribute(a_);
		return t;
	})());
	//@ts-expect-error
	/**@type{XytElement[]}*/ const c = Array.from(v, (v) =>
		Object.assign(t.cloneNode(true), {
			[S]: this.reactive(v),
		})
	);
	e.replaceWith(...c);
	q(c);
};
// FIXME: make less ad-hoc; pass event to event handler
/**@type{any}*/ (d.on).raw =
	/**@type{any}*/ (d.init).raw =
	/**@type{any}*/ (d.data).parent =
	/**@type{any}*/ (d.ref).rw =
	/**@type{any}*/ (d.model).rw =
		true;
const root = /**@type{XytElement?}*/ (
	document.querySelector("[" + X.prefix + "app]")
);
root && X.mount(root);
