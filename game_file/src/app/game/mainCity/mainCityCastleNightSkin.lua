local mainCityDefine = include("mainCityDefine")
local cityBuildCastleSkinConfig = include("cityBuildCastleSkinConfig")
local mainCityCastleNightSkin = class("mainCityCastleNightSkin", function(ccsFileName)
	local target = cc.CSLoader:createNode(ccsFileName)
	target.ccsFileName = ccsFileName
	return target
end)
function mainCityCastleNightSkin:ctor()
	self.criSps, _ENV = nil, nil
	self.Node_spine = SoraDGetChildByName(self, "Node_spine")
	self.Node_shader = SoraDGetChildByName(self, "Node_shader")
end
function mainCityCastleNightSkin:getTintSkin()
	local Node_crpSp = SoraDGetChildByName(self, "Node_crpSp")
	if Node_crpSp then
		Node_crpSp:setCascadeColorEnabled(true)
	end
	return SoraDGetChildByName(self, "castle_light"), Node_crpSp
end
function mainCityCastleNightSkin:initModel(model, castleSkin, pos)
	self.model = model
	self.castleSkin = castleSkin
	self.pos = pos
	local action = cc.CSLoader:createTimeline(self.ccsFileName)
	action:gotoFrameAndPlay(0, true)
	self:runAction(action)
	self:setMixture()
	if self.Node_spine then
		local skinInfo = cityBuildCastleSkinConfig.getSkinInfo(self.model)
		if skinInfo.spineInfo then
			self.spine = sp.SkeletonAnimation:create(skinInfo.spineInfo.skel, skinInfo.spineInfo.atlas, 1)
			self.spine:setPosition(skinInfo.spineInfo.offset)
			self.spine:addTo(self.Node_spine)
			self.spine:setAnimation(0, skinInfo.spineInfo.nightModel, true)
		end
	end
	if self.Node_shader and self.model == BUILD_CASTLE_MODEL.CONSTRUCTED then
		for k, v in pairs(mainCityDefine.castleConstructedCfg) do
			self:createShaderEffect(v, self.Node_shader)
		end
	end
	if self.model == BUILD_CASTLE_MODEL.GOLDENCITY and self.castleSkin and not self.timer then
		self.timer = SoradCreateTimer(self, handler(self, self.update), true)
	end
	if self.Node_shader and self.model == BUILD_CASTLE_MODEL.SOARCASTLE then
		for k, v in pairs(mainCityDefine.castleSoarCfg) do
			self:createShaderEffect(v, self.Node_shader)
		end
	end
	if self.model == BUILD_CASTLE_MODEL.CORBAN2021 then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb1 = cc.criSprite.createCriSprite("2021kafeicb_night1.usm", false, true)
		criSp_cb1:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb1)
		criSp_cb1:addTo(Node_criSp, 0)
		criSp_cb1:setPosition(0, 60)
		criSp_cb1:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		local criSp_cb2 = cc.criSprite.createCriSprite("G_2021kafeicb_night2.usm", false, true)
		criSp_cb2:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb2)
		criSp_cb2:addTo(Node_criSp, 1)
		criSp_cb2:setPosition(0, 60)
		criSp_cb2:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.ICEWOLF then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_bingxuecb_01.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-30, -45)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.KOH2022RAMADAN then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_2022zhaiyuecb.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(0, 80)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.BYZANTINE then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_baizhantingcb.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(0, 0)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.CORBAN2022 then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_2022zaishengjiecb.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-43, 40)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.SEVENTH then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		if SoraDFIsRA() then
			local criSp_cb = cc.criSprite.createCriSprite("G_sevencb_01.usm", false, true)
			criSp_cb:setIsCheckVisibleInScreen(true)
			table.insert(self.criSps, criSp_cb)
			criSp_cb:addTo(Node_criSp)
			criSp_cb:setPosition(43, 16)
			criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		else
			local criSp_cb = cc.criSprite.createCriSprite("G_ROSsevencb_01.usm", false, true)
			criSp_cb:setIsCheckVisibleInScreen(true)
			table.insert(self.criSps, criSp_cb)
			criSp_cb:addTo(Node_criSp)
			criSp_cb:setPosition(43, 16)
			criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		end
		local criSp_cb3 = cc.criSprite.createCriSprite("sevencb_01.usm", false, true)
		criSp_cb3:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb3)
		criSp_cb3:addTo(Node_criSp)
		criSp_cb3:setPosition(-14, 410)
		criSp_cb3:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		local criSp_cb2 = cc.criSprite.createCriSprite("G_sevencb_02.usm", false, true)
		criSp_cb2:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb2)
		criSp_cb2:addTo(Node_criSp)
		criSp_cb2:setPosition(-12.5, 382.5)
		criSp_cb2:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.STARKING and self.castleSkin then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_xingchencb_01.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-50, -40)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		if not self.timer then
			self.timer = SoradCreateTimer(self, handler(self, self.update), true)
		end
	end
	if self.model == BUILD_CASTLE_MODEL.KINGSTARBATTLE then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_xingchenwangzuo_01.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-20, 90)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.FOOTBALL then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_2022shijiebeicb.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-80, 50)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.ICEDRAGON then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_jianianhuacb2022_01.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(60, 30)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.KOH2023RAMADAN then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_2023zhaiyuecb_ws.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp, 2)
		criSp_cb:setPosition(-110, 40)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		local criSp_deng = cc.criSprite.createCriSprite("2023zhaiyuecb_deng.usm", false, true)
		criSp_deng:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_deng)
		criSp_deng:addTo(Node_criSp, 1)
		criSp_deng:setPosition(292, -158)
		criSp_deng:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	end
	if self.model == BUILD_CASTLE_MODEL.MUSICCASTLESENIOR then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_yqzwcbzb_hhb.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-50, 139)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.MUSICCASTLENORMAL then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_yqzwcbzb_ptb.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-70, 32)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.AFTERNOONDESSERT then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_zaishengjiecb23.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp, 1)
		criSp_cb:setPosition(-60, 38)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		local criSp_cb2 = cc.criSprite.createCriSprite("zaishengjiecb23_02.usm", false, true)
		criSp_cb2:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb2)
		criSp_cb2:addTo(Node_criSp, 2)
		criSp_cb2:setPosition(-60, 38)
		criSp_cb2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	end
	if self.model == BUILD_CASTLE_MODEL.EIGHTH then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb2 = cc.criSprite.createCriSprite("G_feichuancb_ws.usm", false, true)
		criSp_cb2:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb2)
		criSp_cb2:addTo(Node_criSp, 1)
		criSp_cb2:setPosition(-223, 104)
		criSp_cb2:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		if not self.timer then
			self.timer = SoradCreateTimer(self, handler(self, self.update), true)
		end
	end
	if self.model == BUILD_CASTLE_MODEL.ICECASTLE2023 then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("BXJCB_YW.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp, 1)
		criSp_cb:setPosition(154, -39)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	end
	if self.model == BUILD_CASTLE_MODEL.ALLSTARSHIP and self.castleSkin then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("qmx_cb_nc_ws.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-65, -105)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	end
	if self.model == BUILD_CASTLE_MODEL.KOH2024RAMADAN and self.castleSkin then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("castleSkinNight_68.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(60.4, -250)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	end
	if self.model == BUILD_CASTLE_MODEL.DAGGER and self.castleSkin then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_castleSkin_69.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(2, -58)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.BUBBLE9TH and self.castleSkin then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("castleSkin_70.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-10, -90)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	end
end
function mainCityCastleNightSkin:update(dt)
	if self.timer and not tolua.isnull(self.castleSkin.Node_act) then
		self:setPositionY(self.pos.y + self.castleSkin.Node_act:getPositionY())
	end
end
function mainCityCastleNightSkin:checkGLONE(target)
	local nameTB = SoraDStringSplit(target:getName(), "_")
	return nameTB[1] == "mix"
end
function mainCityCastleNightSkin:setMixture(parent)
	local parent = parent or self
	for k, v in ipairs(parent:getChildren()) do
		if #v:getChildren() > 0 then
			self:setMixture(v)
		elseif self:checkGLONE(v) then
			SoraDMixtureGLONE(v)
		end
	end
end
function mainCityCastleNightSkin:createShaderEffect(cfg, target)
	local _shader = require(cfg.shader)
	local _meshData = require(cfg.meshData)
	local _param = require(cfg.param)
	local effectNode = SoraDCreateMeshNode(_meshData, cc.size(1, 1), _shader, _param.param)
	effectNode:setPosition(cc.p(unpack(cfg.position)))
	effectNode:setScale(unpack(cfg.scale))
	effectNode:setVisible(true)
	effectNode:addTo(target)
	if cfg.rotation then
		effectNode:setRotation3D(cc.vec3(unpack(cfg.rotation)))
	end
	if cfg.rotation2D then
		effectNode:setRotation(cfg.rotation2D)
	end
	if cfg.scaleZ then
		effectNode:setScaleZ(cfg.scaleZ)
	end
	if cfg.noCull then
		effectNode:setAutoCull(false)
	end
	return effectNode
end
function mainCityCastleNightSkin:onExitOther()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
return mainCityCastleNightSkin
