local resDesRead = include("resDesRead")
local itemDesRead = include("itemDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_costSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_costSingle", Com_costSingle)
function Com_costSingle:onInit()
	self.fields.Button_jump:setString(i18n("Secret_explore_text_14"))
	self.fields.Button_jump:addClickListener(handler(self, self.onClickJump))
	self:fixChildrenPos()
end
function Com_costSingle:onShow()
end
function Com_costSingle:initData(data)
	self.data = data
	if 1 == data.resType then
		self.fields.icon:setSpriteFrame(resDesRead.getIcon(data.resid))
	elseif 2 == data.resType then
		self.fields.icon:setSpriteFrame(itemDesRead.getIcon(data.resid))
	end
	local total = string.formatnumberthousands(data.rescount)
	local curCount = string.formatnumberthousands(data.curRes)
	resDesRead = itemDesRead.getIcon(data.resid)
	itemDesRead.getIcon(data.resid).total = total
	itemDesRead.getIcon(data.resid).cur = curCount
	local str = i18n("common_text_1641", itemDesRead.getIcon(data.resid))
	self.fields.title:setString(str)
	resDesRead, resDesRead = self.fields.title, self.fields.title.setString
	self.fields.title.setString.__default, self.fields.title.color = self.fields.title, "#C8C8C8"
	local styles = self.fields.title.setString
	if data.enough then
		self.fields.icon_state:setSpriteFrame("bg_main_task05.png")
		self.fields.Button_jump:setVisible(false)
	else
		resDesRead = self.fields.Button_jump.setVisible
		styles.total, self.fields.Button_jump.setVisible.color = self.fields.Button_jump.setVisible, "#FE2E2E"
		self.fields.icon_state:setSpriteFrame("bg_main_task06.png")
		self.fields.Button_jump:setVisible(true)
	end
	resDesRead = true
	;(true).total = total
	;(true).cur = curCount
	local str = i18n_html("common_text_1641", true, styles)
	self.fields.title:setString(str)
end
function Com_costSingle:onClickJump()
	SoraDPlaySound()
	if gIDDef.GOLD == self.data.resid then
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
		paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD09)
	elseif 1 == self.data.resType then
		_ENV, _ENV = gRechargeActiveFromEnum.ROAD09, self.data.resType
		gRechargeActiveFromEnum.ROAD09.resid = self.data.resid
		self.data.resType[1], gRechargeActiveFromEnum.ROAD09.rescount = gRechargeActiveFromEnum.ROAD09, self.data.rescount
		local needResList = self.data.resType
		_ENV = nil
		;(nil).rid = self.data.resid
		;(nil).needResData = needResList
		uiManager:show("resourceBuyView", nil)
	end
end
return Com_costSingle
