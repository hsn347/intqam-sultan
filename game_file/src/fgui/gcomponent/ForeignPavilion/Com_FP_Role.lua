local baseComponent = require("fgui.base.baseComponent")
local Com_FP_Role = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/Com_FP_Role", Com_FP_Role)
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
function Com_FP_Role:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_FP_Role:onShow()
	if display.height < 960 then
		self.fields.role:setPositionY(self.fields.role:getY() + 80)
	end
	if self.inited then
		return
	end
	self:updateRole(exoticPavilionCtrl:getCurDressLv(), true)
end
function Com_FP_Role:updateRole(dressId, isShowIn)
	self.inited = true
	if self.dressId == dressId and not isShowIn then
		return
	end
	self.dressId = dressId
	self.fields.role:setScale(1.0)
	self.fields.role:setEffectPath("spine/meinvguan0" .. dressId .. ".skel")
	self.fields.role.effect:setAnimation(0, isShowIn and "chuxian" or "daiji", not isShowIn)
	self.fields.role.effect:setAnchorPoint(cc.p(0.5, 1.0))
	if isShowIn then
		self.fields.role.effect:registerSpineEventHandler(function(data)
			if data.type == "complete" and "chuxian" == data.animation then
				self.fields.role.effect:setAnimation(0, "daiji", true)
			end
		end, sp.EventType.ANIMATION_COMPLETE)
	end
end
function Com_FP_Role:showOutAction(dressId, callback)
	self.fields.bg:setScale(1.2)
	self.fields.bg:stopAllActions()
	self.fields.bg:runAction(ffa.seq(ffa.delay(2.0), ffa.scaleTo(1.0, 1.0), ffa.callFunc(function()
		if callback then
			callback()
		end
	end)))
	self:updateRole(dressId, false)
	self.fields.role.effect:setOpacity(0)
	self.fields.role.effect:stopAllActions()
	_UPVALUE2_ = false
	;(false)[1] = cca.delay(2.0)
	;(false)[2] = cca.callFunc(function()
		self.fields.role.effect:setAnimation(0, "chuxian", false)
		self.fields.role.effect:registerSpineEventHandler(function(data)
			if data.type == "complete" and "chuxian" == data.animation then
				self.fields.role.effect:setAnimation(0, "daiji", true)
			end
		end, sp.EventType.ANIMATION_COMPLETE)
	end)
	;(false)[3] = cca.fadeIn(0.5)
	;(false)[4] = cca.fadeIn(0.5)
	self.fields.role.effect:runAction(cca.seq(false))
end
function Com_FP_Role:showInAction(dressId, callback)
	self.endCallBack = callback
	self.fields.bg:setScale(1.0)
	self.fields.bg:stopAllActions()
	self.fields.bg:runAction(ffa.seq(ffa.scaleTo(1.0, 1.2), ffa.callFunc(function()
		if callback then
			callback()
		end
	end)))
	self:updateRole(dressId, false)
	self.fields.role.effect:runAction(cca.fadeOut(0.5))
	self.fields.Usm_1:setBlendFunc(gl.ONE, gl.SRC_ALPHA)
	self.fields.Usm_1:setEffectPath("chuangliandonghua.usm,chuanglianxunhuan.usm", true)
end
function Com_FP_Role:setChat(type1, type2, lastTime, endCallback)
	self.fields.chat:setChat(type1, type2, lastTime, endCallback)
end
function Com_FP_Role:showChat(chatStr, lastTime, endCallback)
	self.fields.chat:showChat(chatStr, lastTime, endCallback)
end
function Com_FP_Role:hideChat()
	self.fields.chat:stopAllActions()
	self.fields.chat:setVisible(false)
end
return Com_FP_Role
