local buffDesRead = include("buffDesRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local activity_9001656_Read = include("activity_9001656_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001656_BuffItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001656/Com_9001656_BuffItem", Com_9001656_BuffItem)
function Com_9001656_BuffItem:onInit()
	self:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_9001656_BuffItem:onShow()
end
function Com_9001656_BuffItem:initData(buffType, activityID)
	print("buffType", buffType)
	self.buffList, _ENV = print, print
	for i = 1, 2 do
		local buffInfo = activity_9001656_Read.getBuffInfo(activityID, buffType, i)
		dump(buffInfo, "buffInfo")
		if buffInfo then
			self:updateBuffList(buffInfo, i)
		end
		if not self.limitLv then
			self.limitLv = buffInfo.CastleLv
		end
	end
	if self.limitLv then
		if buffType == 2 then
			_ENV = activity_9001656_Read.getBuffInfo(activityID, buffType, i)
			activity_9001656_Read.getBuffInfo(activityID, buffType, i).lv = string.format("%d~%d", self.limitLv[1], self.limitLv[2])
			self.fields.title:setString(i18n("Glory_text_24", (activity_9001656_Read.getBuffInfo(activityID, buffType, i))))
		elseif buffType == 3 then
			local cityltCtrl = include("cityltCtrl")
			self.fields.title:setString(cityltCtrl.getStarBraveStatueLvStr(self.limitLv[2]))
		elseif buffType == 4 then
			_ENV = cityltCtrl.getStarBraveStatueLvStr(self.limitLv[2])
			cityltCtrl.getStarBraveStatueLvStr(self.limitLv[2]).lv1 = self.limitLv[1]
			cityltCtrl.getStarBraveStatueLvStr(self.limitLv[2]).lv2 = self.limitLv[2]
			self.fields.title:setString(i18n("MagiclampDecree_09", cityltCtrl.getStarBraveStatueLvStr(self.limitLv[2])))
		end
	end
	self.keyList, _ENV = self.fields.title.setString, self.fields.title.setString
	for k, v in pairs(self.buffList) do
		table.insert(self.keyList, k)
	end
	self.fields.List:setNumItems(#self.keyList)
	self.fields.List:resizeToFit(#self.keyList)
end
function Com_9001656_BuffItem:updateBuffList(buffInfo, index)
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
function Com_9001656_BuffItem:onItemRenderer(index, target)
	local lineIndex = index
	target:initData(self.buffList[self.keyList[index + 1]], lineIndex)
end
return Com_9001656_BuffItem
