import monaco, {
	require,
	// @ts-expect-error
} from "https://cdn.jsdelivr.net/npm/monaco-editor/+esm";

require.config({
	paths: { vs: "https://cdn.jsdelivr.net/npm/monaco-editor/min/vs" },
});
await new Promise((resolve) => require(["vs/editor/editor.main"], resolve));

export default class Monaco extends HTMLElement {
	static observedAttributes = /** @type {const} */ (["theme"]);
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
		this.shadowRoot?.appendChild(Monaco.template.content.cloneNode(true));
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
		const editor = monaco.editor.create(el, {
			automaticLayout: true,
			theme: "dracula",
		});
		Object.defineProperty(el, "value", {
			get() {
				return editor.getValue();
			},
		});
	}

	disconnectedCallback() {
		if (this.handle !== undefined) {
			clearInterval(this.handle);
		}
	}

	/** @param {typeof Monaco["observedAttributes"][number]} name @param {string} _oldValue @param {string} newValue */
	attributeChangedCallback(name, _oldValue, newValue) {
		switch (name) {
			case "theme": {
				this.theme = newValue;
				break;
			}
		}
	}
}

const tag = new URLSearchParams(import.meta.url.match(/#(.+)/)?.[1]).get(
	"component"
);
if (tag !== null) {
	customElements.define(tag || "x-monaco", Monaco);
}
