local djRead = include("djRead")
local djCtrl = SoraDGetCtrl("djCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_lineSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/Com_lineSingle", Com_lineSingle)
function Com_lineSingle:onInit()
	self.fields.Btn_quest:addClickListener(handler(self, self.onClick_Btn_quest))
	self:fixChildrenPos()
end
function Com_lineSingle:onShow()
end
function Com_lineSingle:initData(data, isLastOne)
	self.data = data
	self.fields.line:setVisible(not isLastOne)
	self.fields.Text_title:setString(self.data.title)
	self.fields.Btn_quest:setVisible(self.data.enum ~= nil)
	self.fields.Label_time:setVisible(false)
	if not self.data.style then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_val:setString(self.data.val)
		self.fields.Text_val:setVisible(not self.data.isTime)
		self.fields.Label_time:setVisible(self.data.isTime or false)
		if self.data.isTime and djCtrl.isBroadcastDJ then
			self.fields.Label_time:beginTime(self.data.val, true)
		else
			self.fields.Label_time:setString("00:00:00")
		end
	elseif self.data.style == 1 then
		self.controllers.c1:setSelectedIndex(1)
		if self.data.val == 0 then
			self.controllers.c1:setSelectedIndex(0)
			self.fields.Text_val:setString(i18n("Anchor_text_169"))
		else
			self.fields.Lab_lvShow:initData(self.data.val)
		end
	elseif self.data.style == 2 then
		self.controllers.c1:setSelectedIndex(2)
		if self.data.val == 0 then
			self.controllers.c1:setSelectedIndex(0)
			self.fields.Text_val:setString(i18n("Anchor_text_169"))
		else
			local cfg = djRead.getLifeLvCfg(self.data.val)
			self.fields.Lab_honor:setTitle(i18n(cfg.nameLife))
			self.fields.Lab_honor:setIcon(cfg.picLife)
		end
	elseif self.data.style == 3 then
		self.controllers.c1:setSelectedIndex(0)
		local cfg = djRead.getAnchorLvCfg(self.data.val)
		self.fields.Text_val:setString(i18n(cfg.nameAnchor))
		self.fields.Text_val:setColor(djRead.getColorByLv(self.data.val, 3))
	end
end
function Com_lineSingle:onClick_Btn_quest(context)
	SoraDPlaySound()
	if self.data.enum == djRead.detailEnum.month_lv then
		_ENV = nil
		;(nil).tag = 1
		uiManager:show("DjLvShow", nil)
	elseif self.data.enum == djRead.detailEnum.live_honor then
		_ENV = nil
		;(nil).tag = 2
		uiManager:show("DjLvShow", nil)
	elseif self.data.enum == djRead.detailEnum.mohth_rank then
		_ENV = nil
		;(nil).tag = 1
		;(nil).isDJ = self.data.isDJ
		uiManager:show("DjValueRankView", nil)
	elseif self.data.enum == djRead.detailEnum.live_rank then
		_ENV = nil
		;(nil).tag = 2
		;(nil).isDJ = self.data.isDJ
		uiManager:show("DjValueRankView", nil)
	elseif self.data.enum == djRead.detailEnum.anchor_lv then
		uiManager:show("DjLvPop")
	end
end
return Com_lineSingle
