local baseComponent = require("fgui.base.baseComponent")
local Chestaccumulated = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity2112/Chestaccumulated1", Chestaccumulated)
function Chestaccumulated:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function Chestaccumulated:onShow()
end
function Chestaccumulated:initData(cfg, isComplete, price, isToday)
	_ENV = nil
	;(nil).num = cfg.time
	self.fields.text_day:setString(i18n("newYearRecharge_003", nil))
	local color = price >= cfg.quantity and self.fields.text_need_desc:getColor() or cc.c3b(255, 50, 50)
	_ENV = i18n("newYearRecharge_003", nil)
	i18n("newYearRecharge_003", nil).num1 = price
	_ENV, _ENV, i18n("newYearRecharge_003", nil).num2 = i18n("newYearRecharge_003", nil)
	_ENV, cfg.quantity.num1, i18n("newYearRecharge_003", nil).color = i18n("newYearRecharge_003", nil)
	cfg.quantity.num2, i18n("newYearRecharge_003", nil).color = i18n("newYearRecharge_003", nil)
	self.fields.text_need_desc:setString(i18n_html(isToday and "newYearRecharge_008" or "newYearRecharge_004", i18n("newYearRecharge_003", nil)))
	_UPVALUE2_ = i18n_html(isToday and "newYearRecharge_008" or "newYearRecharge_004", i18n("newYearRecharge_003", nil))
	i18n_html(isToday and "newYearRecharge_008" or "newYearRecharge_004", i18n("newYearRecharge_003", nil))[1] = "id"
	i18n_html(isToday and "newYearRecharge_008" or "newYearRecharge_004", i18n("newYearRecharge_003", nil))[2] = "num"
	self.rewards = serviceFunctions.tableFormat(cfg.reward, i18n_html(isToday and "newYearRecharge_008" or "newYearRecharge_004", i18n("newYearRecharge_003", nil)))
	self.fields.scroll:setNumItems(#self.rewards)
	self.controllers.c1:setSelectedIndex(isComplete and 1 or 0)
	if isComplete then
		self.fields.text_get:setString(i18n("common_text_1892"))
	end
	if isToday then
		self.fields.Usm_1:setVisible(true)
		self.fields.Usm_1:setEffectPath("G_sp_xncz_002.usm")
		self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	else
		self.fields.Usm_1:setVisible(false)
	end
end
function Chestaccumulated:onItemRenderer(index, obj)
	obj:initData(self.rewards[index + 1].id, self.rewards[index + 1].num)
	obj:setMovieBorder(self.rewards[index + 1].id == 835201, cc.c3b(255, 207, 157))
end
return Chestaccumulated
