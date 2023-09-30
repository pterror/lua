// @ts-check
/** @template {Element} T */
class $ {
	/** @type {T} */ el;
	/** @param {T} el */
	constructor(el) {
		this.el = el;
	}
	/** @param {string} attr @param {string} val */
	attr(attr, val) {
		this.el.setAttribute(attr, val);
		return this;
	}
	/** @param {string[]} classes */
	class(...classes) {
		this.el.classList.add(...classes);
		return this;
	}
	/** @param {string} text */
	text(text) {
		/** @type {HTMLElement} */ (/** @type {Element} */ (this.el)).innerText =
			text;
		return this;
	}
	/** @param {string} html */
	html(html) {
		/** @type {HTMLElement} */ (/** @type {Element} */ (this.el)).innerHTML =
			html;
		return this;
	}
	/** @param {(el: $) => void} f */
	do(f) {
		f(this);
		return this;
	}
	/** @param {string} sel @param {(el: $) => void} f */
	$(sel, f) {
		const el = document.querySelector(sel);
		el && f(new $(el));
		return this;
	}
	/** @template {keyof HTMLElementTagNameMap} Tag */
	/** @param {Tag} tag @param {(el: $<HTMLElementTagNameMap[Tag]>) => void} f */
	append(tag, f) {
		f(new $(this.el.appendChild(document.createElement(tag))));
		return this;
	}
	/** @template {keyof SVGElementTagNameMap} Tag */
	/** @param {Tag} tag @param {(el: $<SVGElementTagNameMap[Tag]>) => void} f */
	appendSvg(tag, f) {
		f(
			new $(
				this.el.appendChild(
					document.createElementNS("http://www.w3.org/2000/svg", tag)
				)
			)
		);
		return this;
	}
	/** @template {keyof MathMLElementTagNameMap} Tag */
	/** @param {Tag} tag @param {(el: $<MathMLElementTagNameMap[Tag]>) => void} f */
	appendMathML(tag, f) {
		f(
			new $(
				this.el.appendChild(
					document.createElementNS("http://www.w3.org/1998/Math/MathML", tag)
				)
			)
		);
		return this;
	}
}
/** @param {string} sel */
const $$ = (sel) => {
	const el = document.querySelector(sel);
	if (el) {
		return new $(el);
	}
};
export default $$;
