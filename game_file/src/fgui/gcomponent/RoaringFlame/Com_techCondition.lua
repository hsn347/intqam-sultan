local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local resDesRead = include("resDesRead")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_techCondition = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_techCondition", Com_techCondition)
function Com_techCondition:onInit()
	self.fields.Button_jump:setString(i18n("common_text_062"))
	self.fields.Button_jump:addClickListener(handler(self, self.btnJumpClick))
	self.fields.Button_jump:setVisible(false)
	self:fixChildrenPos()
end
function Com_techCondition:onShow()
end
function Com_techCondition:initData(param, parent)
	self.param = param
	self.parent = parent
	if param.type == 1 then
		local cfg = roaringFlameWarRead.getTechnologyCfg(param.data.id, param.data.lv)
		self.fields.icon:setSpriteFrame(cfg.icon)
		roaringFlameWarRead = nil
		;(nil).science = i18n(cfg.name)
		;(nil).lv = param.data.lv
		self.fields.title:setString(i18n("common_text_336", nil))
		local preTechLv = roaringFlameWarCtrl:getTechnologyLv(param.data.id)
		local isReach = preTechLv and preTechLv >= param.data.lv
		self.fields.title:setColor(isReach and cc.c3b(240, 230, 210) or cc.c3b(224, 43, 43))
		self.fields.nYes:setVisible(isReach)
		self.fields.nNo:setVisible(not isReach)
		self.fields.Button_jump:setVisible(not isReach)
	elseif param.type == 2 then
		self.fields.icon:setSpriteFrame("1703.png")
		local myCount = roaringFlameWarCtrl:getTechnologyPoint()
		roaringFlameWarRead = not isReach
		;(not isReach).cur = myCount
		;(not isReach).need = param.data
		self.fields.title:setString(i18n("%{cur}/%{need}", not isReach))
		local isReach = myCount >= param.data
		self.fields.title:setColor(isReach and cc.c3b(240, 230, 210) or cc.c3b(224, 43, 43))
		self.fields.nYes:setVisible(isReach)
		self.fields.nNo:setVisible(not isReach)
		self.fields.Button_jump:setVisible(false)
	elseif param.type == 3 then
		self.fields.icon:setSpriteFrame("icon_9001674_rk_lichengbei.png")
		roaringFlameWarRead = false
		;(false).val = param.data
		self.fields.title:setString(i18n("flames_dunes_text83", false))
		local status = roaringFlameWarRead.getDuneHistoryStatus(param.data)
		local isReach = status == 2
		self.fields.title:setColor(isReach and cc.c3b(240, 230, 210) or cc.c3b(224, 43, 43))
		self.fields.nYes:setVisible(isReach)
		self.fields.nNo:setVisible(not isReach)
		self.fields.Button_jump:setVisible(false)
	end
end
function Com_techCondition:btnJumpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).tid = self.param.data.id
	uiManager:show("RoaringFlame_TechDetail", nil)
	if self.parent then
		self.parent:close()
	end
end
return Com_techCondition
