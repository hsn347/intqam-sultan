local itemDesRead = include("itemDesRead")
local worldMapDefine = include("worldMapDefine")
local mailItemDetailMonsterSummary = include("mailItemDetailMonsterSummary")
local mailWrathBeastFightInfo = class("mailWrathBeastFightInfo", mailItemDetailMonsterSummary)
function mailWrathBeastFightInfo:createUI()
	self:setCascadeOpacityEnabled(true)
	mailWrathBeastFightInfo.super.createUI(self)
	self.widthLayout = gMailDetaiViewWidth
	self.heightLayout = 200
end
function mailWrathBeastFightInfo:ctor()
	mailWrathBeastFightInfo.super.ctor(self)
	SoraDGetChildByName(self, "img_line"):setVisible(false)
	self.text_power:setString(i18n("god_beast_text_44"))
	self.text_total:setString(i18n("mail_god_beast_text_08"))
	self.text_wounded:setString(i18n("mail_god_beast_text_07"))
	self.text_remain:setString(i18n("mail_god_beast_text_09"))
end
function mailWrathBeastFightInfo:initWithData(data)
	if nil == data then
		return
	end
	local lastHP = data.lastHP
	local normalHP = data.normalHP
	local orgLifeNum = data.orgLifeNum
	local maxLife = lastHP + (orgLifeNum - 1) * normalHP
	local totalCutLife = data.totalCutLife
	local playerCutLife = data.playerCutLife
	local percent = string.format("%.2f%%", math.min(1, totalCutLife / maxLife) * 100)
	self.text_power_value:setString(percent)
	self.text_wounded_value:setString(string.formatnumberthousands(playerCutLife))
	if data.isMass then
		self.text_total_value:setString(string.formatnumberthousands(totalCutLife))
		local percent = 0
		if totalCutLife ~= 0 then
			percent = playerCutLife / totalCutLife * 100
		end
		percent = string.format("%.1f%%", percent)
		self.text_remain_value:setString(percent)
		self.heightLayout = 200
	else
		self.text_total:setVisible(false)
		self.text_total_value:setVisible(false)
		self.text_remain:setVisible(false)
		self.text_remain_value:setVisible(false)
		self.heightLayout = 120
	end
	local image_crit
	if data.isCrit then
		image_crit = ccui.ImageView:create("icon_youjian_shengshoubaoji.png", ccui.TextureResType.plistType)
		self.contentPanel:addChild(image_crit)
	end
	_UPVALUE4_ = self.contentPanel.addChild
	self.contentPanel.addChild[1] = self.text_remain
	self.contentPanel.addChild[2] = self.text_wounded
	self.contentPanel.addChild[3] = self.text_total
	local self.contentPanel.addChild[4], widgetTab = self.text_power, self.contentPanel.addChild
	local posy = 0
	for i, v in ipairs(widgetTab) do
		if v:isVisible() then
			posy = posy + 40
			v:setPosition(SoraDFPoint(600, posy, self.widthLayout))
		end
	end
	_UPVALUE4_ = ipairs(widgetTab)
	ipairs(widgetTab)[1] = self.text_remain_value
	ipairs(widgetTab)[2] = self.text_wounded_value
	ipairs(widgetTab)[3] = self.text_total_value
	ipairs(widgetTab)[4] = self.text_power_value
	for i, v in ipairs(ipairs(widgetTab)) do
		local width = widgetTab[i]:getContentSize().width
		v:setPosition(SoraDFPoint(600 - width - 10, widgetTab[i]:getPositionY(), self.widthLayout))
	end
	if image_crit then
		local widget = data.isMass and self.text_total_value or self.text_wounded_value
		local x, y = widget:getPosition()
		image_crit:setPosition(cc.p(x - SoraDFSign(widget:getContentSize().width + image_crit:getContentSize().width / 2 + 5), y))
	end
	self.contentPanel:setContentSize(cc.size(gMailDetaiViewWidth, self.heightLayout))
	local itemSize = self.contentPanel:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
return mailWrathBeastFightInfo
