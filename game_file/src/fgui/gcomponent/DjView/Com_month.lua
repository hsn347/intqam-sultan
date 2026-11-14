local djRead = include("djRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_month = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/Com_month", Com_month)
function Com_month:onInit()
	self.fields.Text_none:setString(i18n("legendaryking_text_109"))
	self.fields.Text_none:setVisible(false)
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_l:addClickListener(handler(self, self.onClick_Button_l))
	self.fields.Button_r:addClickListener(handler(self, self.onClick_Button_r))
	self.fields.Text_tip:setString(i18n("Anchor_text_83"))
end
function Com_month:onShow()
end
function Com_month:initData(data)
	self.selfInfo = data
	self.curLv = djRead.getMonthLvByExp(self.selfInfo.monthExp)
	self.curValue = self.selfInfo.monthExp
	self.maxLv = djRead.getMonthMaxLv()
	self.showLv = math.max(1, self.curLv)
	local nextLv = math.min(self.curLv + 1, self.maxLv)
	local nextCfg = djRead.getMonthLvCfg(nextLv)
	self.fields.Text_next:setVisible(self.curLv < self.maxLv)
	if self.curLv < self.maxLv then
		djRead = nil
		;(nil).num = fguiHelper.getColorString("#EA1716", string.formatnumberthousands(nextCfg.valueMonth - self.curValue))
		self.fields.Text_next:setString(i18n("Anchor_text_82", nil))
	end
	if self.curLv > 0 then
		local curCfg = djRead.getMonthLvCfg(self.curLv)
		djRead = i18n("Anchor_text_82", nil)
		i18n("Anchor_text_82", nil).name = fguiHelper.getColorString(djRead.getColorByLv(self.curLv, 1), i18n(curCfg.nameMonth))
		self.fields.Text_cur:setString(i18n("Anchor_text_81", i18n("Anchor_text_82", nil)))
		self.fields.Text_cur:setVisible(0 < #curCfg.rewardMonth)
	else
		djRead = i18n("Anchor_text_81", i18n("Anchor_text_82", nil))
		i18n("Anchor_text_81", i18n("Anchor_text_82", nil)).name = i18n("Anchor_text_169")
		self.fields.Text_cur:setString(i18n("Anchor_text_81", i18n("Anchor_text_81", i18n("Anchor_text_82", nil))))
		self.fields.Text_cur:setVisible(false)
	end
	self:initView()
end
function Com_month:initView()
	local cfg = djRead.getMonthLvCfg(self.showLv)
	self.fields.Text_lv:setString(i18n(cfg.nameMonth))
	self.fields.Text_lv:setColor(djRead.getColorByLv(self.showLv, 1))
	self.reward = cfg.rewardMonth
	self.fields.List:setNumItems(#self.reward)
	self.fields.Text_none:setVisible(#self.reward == 0)
end
function Com_month:itemRenderer_List(index, obj)
	local data = self.reward[index + 1]
	obj:initData(data.id, data.count)
end
function Com_month:onClick_Button_l(context)
	SoraDPlaySound()
	self.showLv = self.showLv - 1
	if self.showLv < 1 then
		self.showLv = self.maxLv
	end
	self:initView()
end
function Com_month:onClick_Button_r(context)
	SoraDPlaySound()
	self.showLv = self.showLv + 1
	if self.showLv > self.maxLv then
		self.showLv = 1
	end
	self:initView()
end
return Com_month
