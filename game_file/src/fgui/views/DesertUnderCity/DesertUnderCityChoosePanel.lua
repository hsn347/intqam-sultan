local publicRead = include("publicRead")
local flameSecretOrderRead = include("flameSecretOrderRead")
local desertUnderCityCtrl = SoraDGetCtrl("desertUnderCityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DesertUnderCityChoosePanel = class("DesertUnderCityChoosePanel", baseFguiPanel)
function DesertUnderCityChoosePanel:ctor(...)
	self.super.ctor(self, ...)
	print("DesertUnderCityChoosePanel:ctor", self.viewName)
end
function DesertUnderCityChoosePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DesertUnderCityChoosePanel:onInit()
	print("=======DesertUnderCityChoosePanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("desert_dungeons_06"))
	self.fields.Text_AwardTitke:setString(i18n("desert_dungeons_07"))
	self.fields.Button_Choose:setTitleText(i18n("common_text_204"))
	self.fields.Button_Choose:addClickListener(handler(self, self.btnGetCallback))
	self.fields.List_Reward:setItemRenderer(handler(self, self.onItemRederer))
end
function DesertUnderCityChoosePanel:onShow()
	print("=======DesertUnderCityChoosePanel:onShow")
	local floorNum = desertUnderCityCtrl:getFloor()
	local rewardList = flameSecretOrderRead.getGreatRewardsByFloor(floorNum, true)
	flameSecretOrderRead = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.rewardConfig = serviceFunctions.tableFormat(rewardList, nil)
	self.fields.List_Reward:setNumItems(table.nums(self.rewardConfig))
	self.fields.Button_Choose:setEnabled(false)
	local type = flameSecretOrderRead.getFloorType(floorNum, true)
	local endFloor = flameSecretOrderRead.getNexFloor(floorNum, true)
	local chooseID = desertUnderCityCtrl:getChooseID()
	if type == 1 then
		local str = floorNum
		if floorNum ~= endFloor then
			str = str .. "-" .. endFloor
		end
		_ENV = table.nums(self.rewardConfig)
		table.nums(self.rewardConfig).num = str
		self.fields.Text_AwardTitke:setString(i18n("desert_dungeons_12", table.nums(self.rewardConfig)))
	else
		self.fields.Text_AwardTitke:setString(i18n("desert_dungeons_07"))
	end
	if self.rewardConfig[chooseID] then
		self.fields.Item_Icon:setURL(publicRead.getIcon(self.rewardConfig[chooseID].id))
	else
		self.fields.Item_Icon:setURL("frame_Desert_dungeons_jiahao.png")
	end
end
function DesertUnderCityChoosePanel:btnGetCallback()
	SoraDPlaySound()
	if not self.curSelectIndex then
		SoraDShowMsgTip(i18n("birthday_text_03"))
		return
	end
	desertUnderCityCtrl:reqChoose(self.curSelectIndex)
	SoraDShowLoading()
	self:removeFromParent()
end
function DesertUnderCityChoosePanel:onItemRederer(index, object)
	object:initData(self.rewardConfig[index + 1], index + 1, self.curSelectIndex)
	object:setHandle(handler(self, self.onClickItemBack))
end
function DesertUnderCityChoosePanel:onClickItemBack(index)
	if self.curSelectIndex == index then
		return
	end
	self.curSelectIndex = index
	local chooseID = desertUnderCityCtrl:getChooseID()
	self.fields.Item_Icon:setURL(publicRead.getIcon(self.rewardConfig[index].id))
	self.fields.Button_Choose:setEnabled(chooseID ~= self.curSelectIndex)
	self.fields.List_Reward:setNumItems(table.nums(self.rewardConfig))
end
return DesertUnderCityChoosePanel
