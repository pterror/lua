const af = (async () => {}).constructor;
/**@type{Record<string,(scope:unknown)=>Promise<unknown>>}*/
const fs = {};
/**@type{(expression:string)=>(scope:unknown)=>Promise<unknown>}*/
const fn = (e) => (fs[e] ??= af("$", "with($)return " + e.trim() + ""));
function xyt() {} // for expando
xyt.prefix = document.body?.getAttribute("xyt-prefix") ?? "x-";
xyt.defaultDirective = "bind";
export default xyt;
/**@type Record<string,(element:HTMLElement,value:any,name:string,originalAttributeName:string,queueTransform:(elements:Element[])=>void) => void>*/
xyt._directives = {};
const scope = {};
const S = Symbol("xyt-scope");
/**@type{(element?:?HTMLElement|string)=>Promise<void>}*/
xyt.mount = async function (e) {
	if (typeof (e ??= document.body) == "string")
		e = /**@type{HTMLElement}*/ (document.querySelector(e));
	//@ts-expect-error
	e[S] = Object.create(scope);
	const p = e.getAttribute("xyt-prefix") ?? this.prefix;
	// TODO: .modifiers?
	const re = new RegExp("^(?:" + p + "([^:]+))?(?::(.*))?$");
	const dd = this.defaultDirective;
	/**@type{(c:Element)=>Promise<void>}*/
	//@ts-expect-error
	const x = async (c, s) => {
		//@ts-expect-error
		c[S] ??= s ?? Object.create(c.parentElement?.[S] ?? scope);
		for (const a_ of c.getAttributeNames()) {
			let [, a, n] = a_.match(re) ?? [];
			if (!a && !n) continue;
			a ??= dd;
			const d = this._directives[a];
			if (!d) continue;
			// TODO: run things in parallel? or make it reactive
			try {
				//@ts-expect-error
				const v = await fn(/**@type{string}*/ (c.getAttribute(a_)))(c[S]);
				/**@type{Element[]|undefined}*/ let q;
				d(/**@type{HTMLElement}*/ (c), v, n, a_, (e) => (q ??= []).push(...e));
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
/**@type{(name:string,func:typeof xyt._directives[string])=>void}*/
xyt.directive = function (n, f) {
	this._directives[n] = f;
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
d("on", (e, v, n) => {
	if (n != null) e.addEventListener(n, v);
	else for (const k in v) e.addEventListener(k, v[k]);
});
d("if", (e, v) => {
	// TODO: `this.prefix`?
	if (!v) e.replaceWith(document.createComment(xyt.prefix + "if"));
});
d("for", (e, v, _, a_, q) => {
	const t = /**@type{Element}*/ (e.cloneNode(true));
	t.removeAttribute(a_);
	//@ts-expect-error
	const ps = e.parentElement?.[S] ?? scope;
	const c = Array.from(v, (data) => {
		const e2 = /**@type{Element}*/ (t.cloneNode(true));
		//@ts-expect-error
		e2[S] = Object.assign(Object.create(ps), data, { data });
		return e2;
	});
	e.replaceWith(...c);
	q(c);
});
//@ts-expect-error
d("data", (e, v) => Object.assign(e[S], { data: v }, v));
const root = /**@type{HTMLElement?}*/ (
	document.querySelector("[" + xyt.prefix + "app]")
);
root && xyt.mount(root);
