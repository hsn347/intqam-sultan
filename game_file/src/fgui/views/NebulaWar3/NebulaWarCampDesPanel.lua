local nebula_area_round_des = require_data("nebula_area_round_des").data
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarCampDesPanel = class("NebulaWarCampDesPanel", baseFguiPanel)
function NebulaWarCampDesPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarCampDesPanel:ctor", self.viewName)
	self.curSelect = 1
	self.timeStrs, _ENV, self.pagesCount = #nebula_area_round_des, #nebula_area_round_des, #nebula_area_round_des
end
function NebulaWarCampDesPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NebulaWar"
	end
	return self._packageList
end
function NebulaWarCampDesPanel:onInit()
	print("=======NebulaWarCampDesPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_059"))
	self.fields.List_page:setItemRenderer(handler(self, self.onPageItemRenderer))
	self.fields.List_page:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onScrollEnd))
	self.fields.Button_left:addClickListener(handler(self, self.onClickBtnLeft))
	self.fields.Button_right:addClickListener(handler(self, self.onClickBtnRight))
end
function NebulaWarCampDesPanel:onShow()
	print("=======NebulaWarCampDesPanel:onShow")
	_ENV = print
	print[1] = NEBULA_REGION_STATE.ROUND1MATCH
	print[2] = NEBULA_REGION_STATE.ROUND2MATCH
	print[3] = NEBULA_REGION_STATE.ROUND3MATCH
	print[4] = NEBULA_REGION_STATE.ROUND4MATCH
	local print[5], config = NEBULA_REGION_STATE.SETTLE, print
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	for round = 1, 4 do
		local beginTime = nebulaActivityCtrl:getStateBeginTime(config[round])
		local endTime = nebulaActivityCtrl:getStateBeginTime(config[round + 1])
		local timeStr = string.format("%s -- %s", os.date("!%Y/%m/%d %H:%M", beginTime), os.date("!%Y/%m/%d %H:%M", endTime))
		self.timeStrs[round] = timeStr
	end
	self.fields.List_page:setNumItems(self.pagesCount)
	self.fields.List_point:setNumItems(self.pagesCount)
	self.curSelect = self.proxy.param and self.proxy.param.round or 1
	self:updateBtnState()
	self.fields.List_page:scrollToView(self.curSelect - 1)
end
function NebulaWarCampDesPanel:onPageItemRenderer(index, obj)
	local config = nebula_area_round_des[index + 1]
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
	end
	obj.fields.icon:setURL(config.png)
	obj.fields.Com_round:setString(i18n(config.name))
	obj.fields.Text_time:setString(self.timeStrs[index + 1])
	obj.fields.Text_des:setString(i18n(config.des))
end
function NebulaWarCampDesPanel:onScrollEnd(...)
	local itemIndex = self.fields.List_page:getFirstChildInView()
	self.curSelect = itemIndex + 1
	self:updateBtnState()
end
function NebulaWarCampDesPanel:onClickBtnLeft(EventContext)
	SoraDPlaySound()
	self.curSelect = self.curSelect + SoraDFSign(1)
	self.curSelect = math.min(math.max(self.curSelect, 1), self.pagesCount)
	self:updateBtnState()
	self.fields.List_page:scrollToView(self.curSelect - 1, true)
end
function NebulaWarCampDesPanel:onClickBtnRight(EventContext)
	SoraDPlaySound()
	self.curSelect = self.curSelect - SoraDFSign(1)
	self.curSelect = math.min(math.max(self.curSelect, 1), self.pagesCount)
	self:updateBtnState()
	self.fields.List_page:scrollToView(self.curSelect - 1, true)
end
function NebulaWarCampDesPanel:updateBtnState(...)
	if SoraDFIsRA() then
		self.fields.Button_left:setVisible(self.curSelect < self.pagesCount)
		self.fields.Button_right:setVisible(self.curSelect > 1)
	else
		self.fields.Button_left:setVisible(self.curSelect > 1)
		self.fields.Button_right:setVisible(self.curSelect < self.pagesCount)
	end
	self.fields.List_point:setSelectedIndex(self.curSelect - 1)
end
return NebulaWarCampDesPanel
