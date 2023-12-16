// @ts-expect-error
import ace from "https://cdn.jsdelivr.net/npm/ace-builds/+esm";
ace.config.set(
	"basePath",
	"https://cdn.jsdelivr.net/npm/ace-builds/src-min-noconflict/"
);

// FIXME: height is 1 million px?
export default class Ace extends HTMLElement {
	static observedAttributes = /** @type {const} */ (["style", "theme"]);
	static template = (() => {
		const el = document.createElement("template");
		// TODO: is it possible to make the editor's tag input?
		// so .value will work correctly
		el.innerHTML = `<div id="editor"></div>`;
		return el;
	})();
	theme = "ace/theme/dracula";

	constructor() {
		super();
		this.attachShadow({ mode: "open" });
		this.shadowRoot?.appendChild(Ace.template.content.cloneNode(true));
	}

	refresh() {
		// TODO: update theme
	}

	connectedCallback() {
		if (this.handle !== undefined) {
			clearInterval(this.handle);
		}
		this.handle = setInterval(this.refresh.bind(this), 1000);
		const el = this.shadowRoot?.getElementById("editor");
		const editor = ace.edit(el, { theme: this.theme });
		const valueDefinition = {
			get() {
				return editor.getValue();
			},
		};
		Object.defineProperty(el, "value", valueDefinition);
		editor.getSession().on("change", () => {
			const e = new InputEvent("change");
			Object.defineProperty(e, "data", valueDefinition);
			el?.dispatchEvent(e);
		});
	}

	disconnectedCallback() {
		if (this.handle !== undefined) {
			clearInterval(this.handle);
		}
	}

	/** @param {typeof Ace["observedAttributes"][number]} name @param {string} _oldValue @param {string} newValue */
	attributeChangedCallback(name, _oldValue, newValue) {
		switch (name) {
			case "theme": {
				this.theme = newValue;
				break;
			}
			case "style": {
				this.shadowRoot
					?.getElementById("editor")
					?.setAttribute("style", newValue);
				break;
			}
		}
	}
}

const tag = new URLSearchParams(import.meta.url.match(/#(.+)/)?.[1]).get(
	"component"
);
if (tag !== null) {
	customElements.define(tag || "x-ace", Ace);
}
