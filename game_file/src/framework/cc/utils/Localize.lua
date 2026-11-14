local Localize.strings, _ENV, _ENV, Localize
function Localize.loadStrings(strings)
	Localize.strings = strings
end
function Localize.query(key, default)
	default = default or key
	local lang = device.language
	if not Localize.strings[lang] or not Localize.strings[lang][key] then
		return default
	end
	return Localize.strings[lang][key]
end
function Localize.filename(filenameOrigin)
	local fi = io.pathinfo(filenameOrigin)
	return fi.dirname .. fi.basename .. "_" .. device.language .. fi.extname
end
if not cc then
	_ENV = cc
end
cc = cc
if not cc.utils then
	_ENV = cc.utils
end
cc.utils = cc.utils
cc.utils.Localize = Localize
return Localize
