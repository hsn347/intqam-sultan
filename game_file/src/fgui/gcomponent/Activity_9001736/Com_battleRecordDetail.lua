local baseComponent = require("fgui.base.baseComponent")
local Com_battleRecordDetail = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001736/Com_battleRecordDetail", Com_battleRecordDetail)
function Com_battleRecordDetail:onInit()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.List:setNeedAutoFix(false)
	self.fields.Lab_attack:setString(i18n("chapter_name_407"))
	self.fields.Lab_defend:setString(i18n("common_text_306"))
end
function Com_battleRecordDetail:onShow()
end
function Com_battleRecordDetail:initData(data)
	if not data.enemyInfo then
		local _UPVALUE0_, enemyInfo = data.enemyInfo, data.enemyInfo
	end
	local power = enemyInfo.power or 0
	self.fields.Text_power:setString(power)
	local isChallenge = data.isChallenge or false
	self.fields.Lab_attack:setSelected(isChallenge)
	self.fields.Lab_defend:setSelected(not isChallenge)
	if not enemyInfo.seedList then
		local _UPVALUE0_, seedList = enemyInfo.seedList, enemyInfo.seedList
	end
	self.seedList = seedList
	self.fields.List:setNumItems(#self.seedList)
end
function Com_battleRecordDetail:itemRenderer_List(index, obj)
	local data = self.seedList[index + 1]
	data.id = data.seedId
	obj:initData(data)
end
return Com_battleRecordDetail
