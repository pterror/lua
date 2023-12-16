const prefixRaw = new URLSearchParams(import.meta.url.match(/#(.+)/)?.[1]).get(
	"component"
);
const prefix =
	prefixRaw === null ? null : encodeURIComponent(prefixRaw || "x") + "-";
const params =
	prefix === null
		? () => ""
		: /** @param {string} name */
		  (name) => "#component=" + prefix + name;
export const [dateTime, ace, monaco] = await Promise.all([
	import("./dateTime.js" + params("date-time")),
	import("./ace.js" + params("ace")),
	import("./monaco.js" + params("monaco")),
]);
