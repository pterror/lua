const monthsLong = [
	"January",
	"February",
	"March",
	"April",
	"May",
	"June",
	"July",
	"August",
	"September",
	"October",
	"November",
	"December",
];
const monthsMedium = [
	"Jan",
	"Feb",
	"Mar",
	"Apr",
	"May",
	"Jun",
	"Jul",
	"Aug",
	"Sep",
	"Oct",
	"Nov",
	"Dec",
];
const monthsShort = [
	"J",
	"F",
	"M",
	"A",
	"M",
	"J",
	"J",
	"A",
	"S",
	"O",
	"N",
	"D",
];
const daysOfWeekLong = [
	"Monday",
	"Tuesday",
	"Wednesday",
	"Thursday",
	"Friday",
	"Saturday",
	"Sunday",
];
const daysOfWeekMedium = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"];
const daysOfWeekShort = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
const daysOfWeekShorter = ["M", "T", "W", "Th", "F", "Sa", "Su"];

export default class DateTime extends HTMLElement {
	static observedAttributes = /** @type {const} */ ([
		"format",
		"update-interval",
	]);
	static template = (() => {
		const el = document.createElement("template");
		el.innerHTML = `<span id="display"> </span>`;
		return el;
	})();
	format = "%hh:%mm:%ss %am";
	/** @type {number | undefined} */
	handle;
	updateInterval = 1000;

	constructor() {
		super();
		this.attachShadow({ mode: "open" });
		this.shadowRoot?.appendChild(DateTime.template.content.cloneNode(true));
	}

	refresh() {
		const date = new Date();
		const oldText = this.shadowRoot?.getElementById("display")?.childNodes[0];
		if (oldText) {
			oldText.replaceWith(
				document.createTextNode(
					this.format.replace(
						/%(YYYY|YY|MMMM|MMM|MM|DD|dddd|ddd|dd|d|HH|hh|mm|ss|ampm|am|pm|AMPM|AM|PM)/g,
						(_, m) => {
							switch (m) {
								case "YYYY": {
									return date.getFullYear().toString();
								}
								case "YY": {
									return date.getFullYear().toString().slice(2);
								}
								case "MMMM": {
									return monthsLong[date.getMonth()];
								}
								case "MMM": {
									return monthsMedium[date.getMonth()];
								}
								case "MM": {
									return (date.getMonth() + 1).toString();
								}
								case "M": {
									return monthsShort[date.getMonth()];
								}
								case "WW": {
									// TODO: add to regex, return week of year
									return m;
								}
								case "DD": {
									return date.getDate().toString();
								}
								case "dddd": {
									return daysOfWeekLong[date.getDay()];
								}
								case "ddd": {
									return daysOfWeekMedium[date.getDay()];
								}
								case "dd": {
									return daysOfWeekShort[date.getDay()];
								}
								case "d": {
									return daysOfWeekShorter[date.getDay()];
								}
								case "HH": {
									return date.getHours().toString().padStart(2, "0");
								}
								case "hh": {
									return (((date.getHours() + 11) % 12) + 1)
										.toString()
										.padStart(2, "0");
								}
								case "mm": {
									return date.getMinutes().toString().padStart(2, "0");
								}
								case "ss": {
									return date.getSeconds().toString().padStart(2, "0");
								}
								case "ms": {
									return date.getMilliseconds().toString().padStart(3, "0");
								}
								case "am":
								case "pm": {
									return date.getHours() >= 12 ? "pm" : "am";
								}
								case "AMPM":
								case "AM":
								case "PM": {
									return date.getHours() >= 12 ? "PM" : "AM";
								}
								default: {
									return m;
								}
							}
						}
					)
				)
			);
		}
	}

	connectedCallback() {
		if (this.handle !== undefined) {
			clearInterval(this.handle);
		}
		this.handle = setInterval(this.refresh.bind(this), 1000);
		this.refresh();
	}

	disconnectedCallback() {
		if (this.handle !== undefined) {
			clearInterval(this.handle);
		}
	}

	/** @param {typeof DateTime["observedAttributes"][number]} name @param {string} _oldValue @param {string} newValue */
	attributeChangedCallback(name, _oldValue, newValue) {
		switch (name) {
			case "format": {
				this.format = newValue;
				break;
			}
			case "update-interval": {
				const n = Number(newValue);
				if (Number.isFinite(n)) {
					this.updateInterval = n;
					this.connectedCallback();
				}
				break;
			}
		}
	}
}

const tag = new URLSearchParams(import.meta.url.match(/#(.+)/)?.[1]).get(
	"component"
);
if (tag !== null) {
	customElements.define(tag || "x-date-time", DateTime);
}
