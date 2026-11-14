local achievementctrl = SoraDGetCtrl("achievementctrl")
local achiDesRead = include("achiDesRead")
local baseComponent = require("fgui.base.baseComponent")
local honourAchiSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/honourAchiSingle", honourAchiSingle)
function honourAchiSingle:onInit()
	self.fields.Button_reward:setString(i18n("common_text_677"))
	self.fields.Button_reward:addClickListener(handler(self, self.btnRewardClick))
	self.fields.Text_already:setString(i18n("common_text_1529"))
	self.fields.Text_already:setVisible(false)
	self.fields.Text_reward:setString(i18n("common_text_2078"))
	self:fixChildrenPos()
	self.fields.bar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function honourAchiSingle:onShow()
end
function honourAchiSingle:initData(data)
	self.data = data
	local info = achiDesRead.getInfoById(self.data.id)
	self.fields.Text_title:setString(i18n(info.achiName))
	self.fields.Text_des:setString(i18n(info.achiDes))
	self.fields.Text_itemDes:setString(string.formatnumberthousands(info.achiGift[2]))
	self.data.cur = math.min(math.floor(self.data.cur), self.data.total)
	self.fields.bar:setMax(self.data.total)
	self.fields.bar:setValue(self.data.cur)
	achiDesRead = string.formatnumberthousands(info.achiGift[2])
	string.formatnumberthousands(info.achiGift[2]).member = string.formatnumberthousands(self.data.cur)
	string.formatnumberthousands(info.achiGift[2]).total = string.formatnumberthousands(self.data.total)
	self.fields.Text_percent:setString(i18n("common_text_155", string.formatnumberthousands(info.achiGift[2])))
	if info.totalSection == info.section and self.data.bingo and self.data.bingo == 1 then
		self.fields.Button_reward:setVisible(false)
		self.fields.Text_already:setVisible(true)
	else
		self.fields.Text_already:setVisible(false)
		self.fields.Button_reward:setVisible(self.data.cur >= self.data.total)
	end
	local spriteAchi = achiDesRead.getShowMedalPic(self.data.medalID, self.data.medalID, self.data.star)
	spriteAchi:setPosition(100, 100)
	self.fields.achi:clearContent()
	self.fields.achi:setContent(spriteAchi)
end
function honourAchiSingle:btnRewardClick()
	if include("pyramidWarltCtrl").checkPwXianXiaSai() then
		achievementctrl:sendReward(self.data.id)
	end
end
return honourAchiSingle
