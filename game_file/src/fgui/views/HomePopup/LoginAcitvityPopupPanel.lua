local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LoginAcitvityPopupPanel = class("LoginAcitvityPopupPanel", baseFguiPanel)
function LoginAcitvityPopupPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	self.isAddToPopManager = true
	print("LoginAcitvityPopupPanel:ctor", self.viewName)
end
function LoginAcitvityPopupPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function LoginAcitvityPopupPanel:onInit()
	print("=======LoginAcitvityPopupPanel:onInit")
	self.popCfg = self.param.popCfg
	if IsArClient then
		self.awards = self.popCfg.reward_KOH
		self.textDes = self.popCfg.text_KOH
	else
		self.awards = self.popCfg.reward_ROS
		self.textDes = self.popCfg.text_ROS
	end
	self.title = SoraDFIsRA() and self.popCfg.nameArt_Ar or self.popCfg.nameArt_En
	self.titleScale = SoraDFIsRA() and self.popCfg.nameArtRatio_Ar or self.popCfg.nameArtRatio_En
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self:updateView()
end
function LoginAcitvityPopupPanel:onShow()
	print("=======LoginAcitvityPopupPanel:onShow")
	self:updateView()
end
function LoginAcitvityPopupPanel:updateView()
	self.fields.text_desc:setString(self.textDes ~= "" and i18n(self.textDes) or self.textDes)
	self.fields.list:setNumItems(#self.awards)
	self:refreshComPage()
end
function LoginAcitvityPopupPanel:refreshComPage()
	if not self.isInit then
		self.isInit = true
		self.fields.Com_icon:getChild("Load_mask"):setTexture("SinglePicture/mask_HomePopup.png")
		self.fields.Label_time = SoraDCreateTimerLabel(self, self.fields.Label_time:getChild("title"))
		self.fields.Label_time:setTimeEndListener(function()
			self:close()
		end)
		local Button_go = self.fields.Com_buttonGo:getChild("Button_normal")
		Button_go:setString(i18n("common_text_477"))
		Button_go:addClickListener(handler(self, self.onClickGo))
		self.bgIcon = self.fields.Com_icon:getChild("icon")
		self.bgPosy = self.bgIcon:getY()
	end
	local activityID = self.popCfg.id
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.bgIcon:setScale(self.popCfg.bgScale)
	self.bgIcon:setURL(self.popCfg.imageBg)
	if self.popCfg.offsety and self.popCfg.offsety > 0 then
		self.bgIcon:setY(self.bgPosy + self.popCfg.offsety)
	else
		self.bgIcon:setY(self.bgPosy)
	end
	self.fields.Load_title:setURL(self.title)
	self.fields.Load_title:setScale(self.titleScale)
	local timer = clientEventMgr.getEventTimer(activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.fields.Label_time:beginTime(leftTime)
	else
		timer = activityShowCtrl:getTimeInfoByID(activityID)
		if timer then
			local leftTime = timer.timerNode.timer:getRemainTime()
			self.fields.Label_time:beginTime(leftTime)
		end
	end
end
function LoginAcitvityPopupPanel:onItemRenderer(index, obj)
	local award = self.awards[index + 1]
	obj:initData(award)
end
function LoginAcitvityPopupPanel:onClickGo(EventContext)
	SoraDPlaySound()
	local activityID = self.popCfg.id
	local callback = self.param and self.param.closeCallback or nil
	self:closePanel()
	if callback then
		callback(activityID)
	else
		clientEventMgr.singleClickEvent(activityID)
	end
end
return LoginAcitvityPopupPanel
