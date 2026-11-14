local pandectRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	pandectRead = nil
	;(nil)[1] = "pandect_list_view"
	pandectRead:defineValue("listView", nil)
	pandectRead = nil
	;(nil)[1] = "pandect_type_view"
	pandectRead:defineValue("typeView", nil)
end
init()
function pandectRead.getTypeViewInfo()
	return pandectRead.typeView
end
function pandectRead.getListViewInfoByType(vType)
	if not pandectRead.getIsFuncUnlock(vType) then
		pandectRead = pandectRead.getIsFuncUnlock(vType)
		return (pandectRead.getIsFuncUnlock(vType))
	end
	local pandectRead, tb = pandectRead.getIsFuncUnlock(vType), pandectRead.getIsFuncUnlock(vType)
	for k, v in ipairs(pandectRead.listView) do
		if v.type == vType and SoraDGetCastleLv() >= v.showLevel then
			table.insert(tb, v)
		end
	end
	return tb
end
function pandectRead.getListInfoByType(vType)
	for k, v in ipairs(pandectRead.listView) do
		if v.type == vType and SoraDGetCastleLv() >= v.showLevel then
			return v
		end
	end
end
function pandectRead.getUnlockLang(vType, sQueue, lv)
	local tb = pandectRead.getListViewInfoByType(vType)
	local lang
	for k, v in ipairs(tb) do
		if v.type == vType and k == sQueue and type(v.lockWords) == "table" and next(v.lockWords) then
			if v.lockWords.lv and lv < v.lockWords.lv then
				lang = i18n(v.lockWords)
			else
				lang = i18n(v.lockWords)
			end
		end
	end
	return lang
end
function pandectRead.getIsShow(vType, sQueue, lv, nextFuncLv)
	local tb = pandectRead.getListViewInfoByType(vType)
	for k, v in ipairs(tb) do
		if v.type == vType and k == sQueue and type(v.lockWords) == "table" and v.lockWords.lv ~= nil and lv < v.lockWords.lv and v.lockWords.lv ~= nextFuncLv then
			return false
		end
	end
	return true
end
function pandectRead.getFuncNextLevel(nowLv)
	local nextLv
	for k, v in pairs(pandectRead.listView) do
		if v.type ~= gPandectType.alliance and v.type ~= gPandectType.arena and type(v.lockWords) == "table" and v.lockWords.lv ~= nil and nowLv < v.lockWords.lv and (nextLv == nil or nextLv > v.lockWords.lv) then
			nextLv = v.lockWords.lv
		end
	end
	return nextLv
end
function pandectRead.getIsFuncUnlock(vType)
	if vType == gPandectType.newbornTree then
		local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
		if not divineBeastCtrl:getIsUnlock() then
			return false
		end
	end
	return true
end
return pandectRead
