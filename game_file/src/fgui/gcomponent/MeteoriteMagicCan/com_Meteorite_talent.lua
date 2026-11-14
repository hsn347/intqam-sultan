local baseComponent = require("fgui.base.baseComponent")
local com_Meteorite_talent = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_talent", com_Meteorite_talent)
local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
local meteorMagicRead = include("meteorMagicRead")
function com_Meteorite_talent:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self:addClickEventListener(handler(self, self.onClicked))
end
function com_Meteorite_talent:onShow()
end
function com_Meteorite_talent:setIDGruop(idGroup, curProjectID)
	self.idGroup = idGroup
	self.curProjectID = curProjectID
	local iconName = meteorMagicRead.getIcon(idGroup)
	self.fields.icon:setIcon(iconName)
	self.fields.iconBg:setURL(meteorMagicRead.getIconBg(idGroup))
	self.isYellow = iconName == "framer_yxmn_bdmn_04.png"
	self.fields.icon:setScale((iconName == "framer_yxmn_jnk_tb.png" or self.isYellow) and 0.7 or 1)
	self.controllers.c2:setSelectedIndex(self:getScale() >= 0.44 and 1 or 0)
end
function com_Meteorite_talent:setData(lv)
	local isActive = false
	self.lv = lv or 0
	self.magicId = meteorMagicRead.getMagicId(self.idGroup, self.lv ~= 0 and self.lv or 1)
	self.magicCfg = meteorMagicRead.getMagicCfg(self.magicId)
	self.isCanUpStar = self:isCanUp()
	self.fields.Effect_1:setVisible(false)
	if self.oldLv == 0 and self.oldLv ~= self.lv then
		_UPVALUE3_ = nil
		;(nil)[1] = ffa.delay(0.5)
		;(nil)[2] = ffa.callFunc(function()
			self.fields.Effect_1:setVisible(true)
			self.fields.Effect_1:setAllFrameName("dh_Tex_XL_xwzb01_0%02d.png", 0)
			self.fields.Effect_1:setColor(self.isYellow and cc.c3b(255, 214, 139) or cc.c3b(255, 255, 255))
			self.fields.Effect_1:setPlaySettings(0, -1, 1)
			self.controllers.c1:setSelectedIndex(0 < self.lv and 1 or 3)
			self.fields.text_lv:setString(self.lv .. "/" .. meteorMagicRead.getMaxLvMagicId(self.idGroup) % 100)
		end)
		;(nil)[3] = ffa.delay(0.48)
		;(nil)[4] = ffa.callFunc(function()
			self.fields.Effect_1:setVisible(false)
		end)
		;(nil)[5] = ffa.callFunc(function()
			self.fields.Effect_1:setVisible(false)
		end)
		self:runAction(ffa.seq(nil))
		isActive = true
	else
		self.controllers.c1:setSelectedIndex(self.lv > 0 and 1 or 3)
		self.fields.text_lv:setString(self.lv .. "/" .. meteorMagicRead.getMaxLvMagicId(self.idGroup) % 100)
	end
	self.fields.sp_shine_active:stopAllActions()
	self.fields.sp_shine_active:setVisible(self.lv > 0)
	self.fields.sp_shine_bg:setVisible(self.lv == 0 and not self.isCanUpStar)
	if self.lv > 0 then
		_ENV = meteorMagicRead.getMaxLvMagicId(self.idGroup) % 100
		;(meteorMagicRead.getMaxLvMagicId(self.idGroup) % 100)[1] = ffa.fadeTo(0.8, 0)
		;(meteorMagicRead.getMaxLvMagicId(self.idGroup) % 100)[2] = ffa.fadeTo(0.8, 1.0)
		;(meteorMagicRead.getMaxLvMagicId(self.idGroup) % 100)[3] = ffa.fadeTo(0.8, 1.0)
		;(meteorMagicRead.getMaxLvMagicId(self.idGroup) % 100)[4] = ffa.fadeTo(0.8, 1.0)
		self.fields.sp_shine_active:runAction(ffa.repeatForever(ffa.seq(meteorMagicRead.getMaxLvMagicId(self.idGroup) % 100)))
	end
	self.oldLv = self.lv
	return isActive
end
function com_Meteorite_talent:showPreview()
	self.fields.sp_shine:stopAllActions()
	self.fields.sp_shine:setVisible(true)
	self.fields.sp_shine_bg:setVisible(true)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.scaleTo(0.0, 1.0)
	;(nil)[2] = ffa.scaleTo(1.0, 1.15)
	;(nil)[3] = ffa.scaleTo(1.0, 1.15)
	;(nil)[4] = ffa.scaleTo(1.0, 1.15)
	self.fields.sp_shine:runAction(ffa.repeatForever(ffa.seq(nil)))
	_UPVALUE1_ = ffa.repeatForever(ffa.seq(nil))
	ffa.repeatForever(ffa.seq(nil))[1] = ffa.fadeTo(0.5, 0.6)
	ffa.repeatForever(ffa.seq(nil))[2] = ffa.fadeTo(0.5, 0)
	ffa.repeatForever(ffa.seq(nil))[3] = ffa.fadeTo(0.5, 0)
	ffa.repeatForever(ffa.seq(nil))[4] = ffa.fadeTo(0.5, 0)
	self.fields.sp_shine:runAction(ffa.repeatForever(ffa.seq(ffa.repeatForever(ffa.seq(nil)))))
end
function com_Meteorite_talent:hidePreview()
	self.fields.sp_shine:stopAllActions()
	self.fields.sp_shine:setVisible(false)
	self.fields.sp_shine_bg:setVisible(self.lv == 0 and not self.isCanUpStar)
end
function com_Meteorite_talent:setData2(lv)
	self.lv = lv or 0
	self.fields.text_lv:setString(self.lv .. "/" .. meteorMagicRead.getMaxLvMagicId(self.idGroup) % 100)
end
function com_Meteorite_talent:onClicked()
	if self.curProjectID == nil then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).idGroup = self.idGroup
	;(nil).curProjectID = self.curProjectID
	uiManager:show("MeteoriteDetails", nil)
end
function com_Meteorite_talent:isCanUp()
	local isSpecifiedAll = true
	for i, v in ipairs(self.magicCfg.specifiedId) do
		local isLvLight = meteorMagicCtrl:getIsLvLight(v, self.curProjectID)
		if not isLvLight then
			isSpecifiedAll = false
		end
	end
	local isThereintoOne = #self.magicCfg.thereintoId == 0
	for i, v in ipairs(self.magicCfg.thereintoId) do
		local isLvLight = meteorMagicCtrl:getIsLvLight(v, self.curProjectID)
		if isLvLight then
			isThereintoOne = true
		end
	end
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local buildLv = cityCtrl:getBuildMaxLv(BUILDID.NEBULA_PALACE)
	local isBuildLv = buildLv >= self.magicCfg.needBuildLv
	_UPVALUE3_ = meteorMagicCtrl:getIsLvLight(v, self.curProjectID)
	meteorMagicCtrl:getIsLvLight(v, self.curProjectID)[1] = isSpecifiedAll
	meteorMagicCtrl:getIsLvLight(v, self.curProjectID)[2] = isThereintoOne
	meteorMagicCtrl:getIsLvLight(v, self.curProjectID)[3] = isBuildLv
	dump(meteorMagicCtrl:getIsLvLight(v, self.curProjectID), "isSpecifiedAll and isThereintoOne and isBuildLv")
	if isSpecifiedAll and isThereintoOne and isBuildLv then
		return true
	else
		return false
	end
end
return com_Meteorite_talent
