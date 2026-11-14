local everydayTaskCtrl = SoraDGetCtrl("everydayTaskCtrl")
local everydayTaskRead = include("everydayTaskRead")
local baseComponent = require("fgui.base.baseComponent")
local com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://QuestView/com_list", com_list)
function com_list:onInit()
	self.fields.Button_touch:addClickListener(handler(self, self.OnBtnClick))
	self.fields.Button_getPrize:setString(i18n("common_text_678"))
	self.fields.Button_getPrize:addClickListener(handler(self, self.OnGoClick))
	self.fields.Btn_pass:addClickListener(handler(self, self.OnPassClick))
	self.fields.Text_nouse:setString(i18n("Actpass_text_03"))
	self.fields.Text_finish:setString(i18n("common_text_2601"))
	self.fields.Sprite_item:fixPos()
	self.fields.Image_black:fixPos()
	self.fields.Bar:fixPos()
	self.fields.Bar:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Text_progress:fixPos()
	self.fields.Text_target:fixPos()
	self.fields.richText:fixPos()
	self.fields.Text_f_score:fixPos()
	self.fields.Text_nouse:fixPos()
	self.fields.Text_finish:fixPos()
	self.fields.Button_getPrize:fixPos()
	self.fields.Btn_pass:fixPos()
end
function com_list:onShow()
end
function com_list:initWithData(data, isReduce)
	self.data = data
	self.isReduce = isReduce
	self.needNum = self.data.passNum
	self.taskId = everydayTaskCtrl:getIndexById(self.data.everydayTaskID)
	local info = everydayTaskRead.getDailyRewardData(self.taskId)
	self.data.itemInfo = info
	self.fields.Sprite_item:setSpriteFrame(info.image)
	self.fields.Text_f_score:setString(self.data.point * self.data.limitTime)
	self.fields.Bar:setMax(self.data.limitTime)
	self.fields.Bar:setValue(self.data.count)
	everydayTaskCtrl = nil
	;(nil).var1 = self.data.count
	;(nil).var2 = self.data.limitTime
	self.fields.Text_progress:setString(i18n("%{var1}/%{var2}", nil))
	everydayTaskCtrl = i18n("%{var1}/%{var2}", nil)
	i18n("%{var1}/%{var2}", nil).num = fguiHelper.getColorString("#416e36", self.data.point)
	self.fields.richText:setString(i18n("common_text_4457", i18n("%{var1}/%{var2}", nil)))
	self.fields.Text_target:setString(i18n(info.name))
	local status = 0
	if self.data.per == 1 then
		status = 1
	elseif self.isReduce then
		status = 0
	elseif self.data.isCanPass then
		status = 2
		self.needNum = self.data.passNum * (self.data.limitTime - self.data.count)
		self.fields.Btn_pass:setString(i18n("Actpass_text_04"))
		self.fields.Btn_pass:setCostTitle(self.needNum)
	else
		status = 3
	end
	self.controllers.c1:setSelectedIndex(status)
end
function com_list:OnBtnClick()
	if self.isReduce then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("dailyAwardItemDetail")
		panel:initWithData(self.data)
		panel:show()
	end
end
function com_list:OnGoClick()
	SoraDPlaySound()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	mildGuideManager:starMildByEverydayTaskID(self.data.everydayTaskID, everydayTaskRead.getJumpData(self.data.everydayTaskID))
	SoraDRemoveAllPanelFromManager()
end
function com_list:OnPassClick()
	SoraDPlaySound()
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local passCount = backpackCtrl:getItemCount(510501)
	if passCount >= self.needNum then
		_ENV = nil
		_ENV = nil
		;(nil).num = self.needNum
		_ENV, (nil).msg = i18n("Actpass_text_05", nil), i18n("Actpass_text_05", nil)
		i18n("Actpass_text_05", nil).gold = self.needNum
		i18n("Actpass_text_05", nil).title = i18n("Actpass_text_04")
		i18n("Actpass_text_05", nil).icon = "5105.png"
		;(nil).param, i18n("Actpass_text_05", nil).taskType = i18n("Actpass_text_05", nil), self.data.type
		;(nil).isEnough = true
		uiManager:show("dailyAwardPassView", nil)
	else
		local shopItemID = 1000214
		local needCount = self.needNum - passCount
		local price = gModuleMgr.sharedMgr("shopltCtrl"):getPrice(shopItemID)
		_ENV = "Actpass_text_04"
		_ENV = nil
		;(nil).num = passCount
		;(nil).count = needCount
		_ENV, ("Actpass_text_04").msg = i18n("Actpass_text_08", nil), i18n("Actpass_text_08", nil)
		i18n("Actpass_text_08", nil).gold = needCount * price
		i18n("Actpass_text_08", nil).title = i18n("common_text_4436")
		i18n("Actpass_text_08", nil).checkGold = true
		;("Actpass_text_04").param, i18n("Actpass_text_08", nil).taskType = i18n("Actpass_text_08", nil), self.data.type
		uiManager:show("dailyAwardPassView", "Actpass_text_04")
	end
end
return com_list
