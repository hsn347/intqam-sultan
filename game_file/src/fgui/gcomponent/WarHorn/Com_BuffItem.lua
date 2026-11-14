local buffDesRead = include("buffDesRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local warOrderRead = include("warOrderRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_BuffItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarHorn/Com_BuffItem", Com_BuffItem)
function Com_BuffItem:onInit()
	self:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_BuffItem:onShow()
end
function Com_BuffItem:initData(buffType, activityID)
	self.buffList, warOrderRead = nil, nil
	for i = 1, 3 do
		local buffInfo = warOrderRead.getBuffInfo(activityID, buffType, i)
		if buffInfo then
			self:updateBuffList(buffInfo, i)
		end
		if not self.limitLv and buffInfo then
			self.limitLv = buffInfo.CastleLv
		end
	end
	if self.limitLv then
		if buffType == 2 then
			warOrderRead = warOrderRead.getBuffInfo(activityID, buffType, i)
			warOrderRead.getBuffInfo(activityID, buffType, i).lv = string.format("%d~%d", self.limitLv[1], self.limitLv[2])
			self.fields.title:setString(i18n("Glory_text_24", (warOrderRead.getBuffInfo(activityID, buffType, i))))
		elseif buffType == 3 then
			local cityltCtrl = include("cityltCtrl")
			self.fields.title:setString(cityltCtrl.getStarBraveStatueLvStr(self.limitLv[2]))
		elseif buffType == 4 then
			warOrderRead = cityltCtrl.getStarBraveStatueLvStr(self.limitLv[2])
			cityltCtrl.getStarBraveStatueLvStr(self.limitLv[2]).lv1 = self.limitLv[1]
			cityltCtrl.getStarBraveStatueLvStr(self.limitLv[2]).lv2 = self.limitLv[2]
			self.fields.title:setString(i18n("MagiclampDecree_09", cityltCtrl.getStarBraveStatueLvStr(self.limitLv[2])))
		end
	end
	self.keyList, warOrderRead = self.fields.title.setString, self.fields.title.setString
	for k, v in pairs(self.buffList) do
		table.insert(self.keyList, k)
	end
	self.fields.List:setNumItems(#self.keyList)
	self.fields.List:resizeToFit(#self.keyList)
end
function Com_BuffItem:updateBuffList(buffInfo, index)
	for _, buffID in ipairs(buffInfo.PrivilegeEffect) do
		local effectType = buffltCtrl:getEffectType(buffID)
		local buffNum1 = buffltCtrl:getEffect(buffID)
		local title, _ = buffDesRead.getTitleBase(effectType, true)
		if not self.buffList[effectType] then
			self.buffList[effectType], _ENV = nil, nil
			self.buffList[effectType].totalBuffNum = 0
		end
		self.buffList[effectType].title = title
		self.buffList[effectType].totalBuffNum = self.buffList[effectType].totalBuffNum + buffNum1
		local value = buffDesRead.getTitleValueWithValue(effectType, self.buffList[effectType].totalBuffNum, true)
		self.buffList[effectType]["value" .. index] = value
	end
end
function Com_BuffItem:initIndex(buffType, activityID, index)
	self.buffList, warOrderRead, self.index = nil, nil, index
	local buffInfo = warOrderRead.getBuffInfo(activityID, buffType, index)
	if buffInfo then
		local CastleLv = buffInfo.CastleLv
		local beginLv = CastleLv[1]
		if beginLv == 0 then
			beginLv = 1
		end
		warOrderRead = nil
		;(nil).lv1 = beginLv
		;(nil).lv2 = CastleLv[2]
		self.fields.title:setString(i18n("MagiclampDecree_09", nil))
		self:updateBuffList(buffInfo, 1)
	end
	self.keyList = table.keys(self.buffList)
	self.fields.List:setNumItems(#self.keyList)
	self.fields.List:resizeToFit(#self.keyList)
end
function Com_BuffItem:onItemRenderer(index, obj)
	local lineIndex = index
	obj:initData(self.buffList[self.keyList[index + 1]], lineIndex)
end
return Com_BuffItem
