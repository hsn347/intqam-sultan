local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ForeignPIntimacyPanel = class("ForeignPIntimacyPanel", baseFguiPanel)
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
local foreignPavilionRead = include("foreignPavilionRead")
function ForeignPIntimacyPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("ForeignPIntimacyPanel:ctor", self.viewName)
end
function ForeignPIntimacyPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
	end
	return self._packageList
end
function ForeignPIntimacyPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======ForeignPIntimacyPanel:onInit")
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.intimacyCfgs = foreignPavilionRead:getIntimacyCfgs()
	self.fields.title:setString(string.upper(i18n("exitic_pavillion_text_0053")))
	self.fields.title2:setString(string.upper(i18n("exitic_pavillion_text_0053")))
end
function ForeignPIntimacyPanel:onShow()
	self.intimacyLv = exoticPavilionCtrl:getCurIntimacyLv()
	self.fields.scroll:setNumItems(#self.intimacyCfgs)
	self.fields.Spine_1:setEffectPath("spine/aixin.skel", nil, false)
	self.fields.Spine_1.effect:registerSpineEventHandler(function(data)
		if data.type == "complete" and "animation" == data.animation then
			self.fields.Spine_1.effect:setAnimation(0, "animation2", true)
		end
	end, sp.EventType.ANIMATION_COMPLETE)
	self.fields.title:setAlpha(0)
	self.fields.title:runAction(ffa.seq(ffa.delay(0.3), ffa.fadeIn(0.43333333333333335)))
	self.fields.title2:setAlpha(0)
	self.fields.title2:runAction(ffa.seq(ffa.delay(0.3), ffa.fadeIn(0.43333333333333335)))
	self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	self.fields.Usm_1:setEffectPath("G_ygg_tanchuang.usm", true)
	print("=======ForeignPIntimacyPanel:onShow")
end
function ForeignPIntimacyPanel:onHide()
	print("=======ForeignPIntimacyPanel:onHide")
end
function ForeignPIntimacyPanel:onDispose()
	print("=======ForeignPIntimacyPanel:onDispose")
end
function ForeignPIntimacyPanel:onItemRenderer(index, obj)
	local intimacyCfg = self.intimacyCfgs[index + 1]
	local isCurIdx = intimacyCfg.intimacy == self.intimacyLv
	obj:initData(intimacyCfg, isCurIdx, index)
	obj:setAlpha(0)
	obj:runAction(ffa.seq(ffa.delay(0.3 + 0.1 * index), ffa.fadeIn(0.2)))
	_UPVALUE1_ = ffa.seq(ffa.delay(0.3 + 0.1 * index), ffa.fadeIn(0.2))
	ffa.seq(ffa.delay(0.3 + 0.1 * index), ffa.fadeIn(0.2))[1] = cca.delay(0.3 + 0.1 * index)
	ffa.seq(ffa.delay(0.3 + 0.1 * index), ffa.fadeIn(0.2))[2] = cca.fadeIn(0.2)
	ffa.seq(ffa.delay(0.3 + 0.1 * index), ffa.fadeIn(0.2))[3] = cca.fadeIn(0.2)
	obj.fields.heart:runLineAction(cca.seq(ffa.seq(ffa.delay(0.3 + 0.1 * index), ffa.fadeIn(0.2))))
end
return ForeignPIntimacyPanel
