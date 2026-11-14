local mainCityDefine = include("mainCityDefine")
local mainCityCastleSkin = class("mainCityCastleSkin", function(ccsFileName)
	local target = cc.CSLoader:createNode(ccsFileName)
	target.ccsFileName = ccsFileName
	return target
end)
function mainCityCastleSkin:ctor()
	self.criSps, _ENV = nil, nil
	self.Image_castle = SoraDGetChildByName(self, "Image_castle")
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	self.Node_spine = SoraDGetChildByName(self, "Node_spine")
	self.Node_act = SoraDGetChildByName(self, "Node_act")
	self.Node_criSp = SoraDGetChildByName(self, "Node_criSp")
	if self.Node_criSp then
		self.Node_criSp:setCascadeColorEnabled(true)
	end
end
function mainCityCastleSkin:getTintSkin()
	return self.Image_castle, self.Node_spine, self.Node_criSp
end
function mainCityCastleSkin:initModel(model, view, info)
	self.model = model
	self.view = view
	self.info = info
	if info.isLoop then
		local action = cc.CSLoader:createTimeline(self.ccsFileName)
		action:gotoFrameAndPlay(0, true)
		self:runAction(action)
	end
	if info.spineInfo then
		self.spine = sp.SkeletonAnimation:create(info.spineInfo.skel, info.spineInfo.atlas, 1)
		self.spine:setPosition(info.spineInfo.offset)
		self.spine:addTo(self.Node_spine)
		self.spine:setAnimation(0, info.spineInfo.dayModel, true)
	end
	self:setMixture()
	self:checkSpecial()
end
function mainCityCastleSkin:checkGLONE(target)
	local nameTB = SoraDStringSplit(target:getName(), "_")
	return nameTB[1] == "mix"
end
function mainCityCastleSkin:setMixture(parent)
	local parent = parent or self
	for k, v in ipairs(parent:getChildren()) do
		if v.getChildren and #v:getChildren() > 0 then
			self:setMixture(v)
		elseif self:checkGLONE(v) then
			SoraDMixtureGLONE(v)
		end
	end
end
function mainCityCastleSkin:setDayStyle()
	if self.Node_effect then
		self.Node_effect:setVisible(true)
	end
	if self.spine then
		self.spine:setAnimation(0, self.info.spineInfo.dayModel, true)
	end
	if self.spine_flag then
		for k, v in ipairs(self.spine_flag) do
			v:stopAllActions()
			v:setAnimation(0, "baitian", true)
		end
	end
	if self.model == BUILD_CASTLE_MODEL.REDGEM then
		if SoraDGetChildByName(self, "Node_gem") then
			SoraDGetChildByName(self, "Node_gem"):setVisible(true)
		end
		if SoraDGetChildByName(self, "Node_gemex") then
			SoraDGetChildByName(self, "Node_gemex"):setVisible(true)
		end
		if self.Node_spine then
			self.Node_spine:setVisible(true)
		end
	end
	if self.model == BUILD_CASTLE_MODEL.FOURTH and SoraDGetChildByName(self, "dh_part_4") then
		SoraDGetChildByName(self, "dh_part_4"):setVisible(true)
	end
	if self.model == BUILD_CASTLE_MODEL.CONSTRUCTED then
		local Node_shader = SoraDGetChildByName(self, "Node_shader")
		if Node_shader then
			Node_shader:setVisible(true)
		end
		local Node_shader_bg = SoraDGetChildByName(self, "Node_shader_bg")
		if Node_shader_bg then
			Node_shader_bg:setVisible(true)
		end
	end
	if self.model == BUILD_CASTLE_MODEL.GOLDENCITY and SoraDGetChildByName(self, "Node_top_effect") then
		SoraDGetChildByName(self, "Node_top_effect"):setVisible(true)
	end
	if self.model == BUILD_CASTLE_MODEL.KOH2021RAMADAN and SoraDGetChildByName(self, "Node_top_effect") then
		SoraDGetChildByName(self, "Node_top_effect"):setVisible(true)
	end
	if self.model == BUILD_CASTLE_MODEL.THUNDERCLOUD then
		local Node_effect_bottom = SoraDGetChildByName(self, "Node_effect_bottom")
		if Node_effect_bottom then
			Node_effect_bottom:setVisible(true)
		end
		local Node_effect_top = SoraDGetChildByName(self, "Node_effect_top")
		if Node_effect_top then
			Node_effect_top:setVisible(true)
		end
	end
	_UPVALUE18_ = Node_effect_bottom
	SoraDGetChildByName(self, "Node_effect_bottom")[1] = BUILD_CASTLE_MODEL.CORBAN2021
	SoraDGetChildByName(self, "Node_effect_bottom")[2] = BUILD_CASTLE_MODEL.ICEWOLF
	SoraDGetChildByName(self, "Node_effect_bottom")[3] = BUILD_CASTLE_MODEL.KOH2022RAMADAN
	SoraDGetChildByName(self, "Node_effect_bottom")[4] = BUILD_CASTLE_MODEL.BYZANTINE
	SoraDGetChildByName(self, "Node_effect_bottom")[5] = BUILD_CASTLE_MODEL.CORBAN2022
	SoraDGetChildByName(self, "Node_effect_bottom")[6] = BUILD_CASTLE_MODEL.SEVENTH
	SoraDGetChildByName(self, "Node_effect_bottom")[7] = BUILD_CASTLE_MODEL.STARKING
	SoraDGetChildByName(self, "Node_effect_bottom")[8] = BUILD_CASTLE_MODEL.KINGSTARBATTLE
	SoraDGetChildByName(self, "Node_effect_bottom")[9] = BUILD_CASTLE_MODEL.FOOTBALL
	SoraDGetChildByName(self, "Node_effect_bottom")[10] = BUILD_CASTLE_MODEL.ICEDRAGON
	SoraDGetChildByName(self, "Node_effect_bottom")[11] = BUILD_CASTLE_MODEL.KOH2023RAMADAN
	SoraDGetChildByName(self, "Node_effect_bottom")[12] = BUILD_CASTLE_MODEL.MUSICCASTLESENIOR
	SoraDGetChildByName(self, "Node_effect_bottom")[13] = BUILD_CASTLE_MODEL.MUSICCASTLENORMAL
	SoraDGetChildByName(self, "Node_effect_bottom")[14] = BUILD_CASTLE_MODEL.AFTERNOONDESSERT
	SoraDGetChildByName(self, "Node_effect_bottom")[15] = BUILD_CASTLE_MODEL.EIGHTH
	SoraDGetChildByName(self, "Node_effect_bottom")[16] = BUILD_CASTLE_MODEL.ICECASTLE2023
	SoraDGetChildByName(self, "Node_effect_bottom")[17] = BUILD_CASTLE_MODEL.ALLSTARSHIP
	SoraDGetChildByName(self, "Node_effect_bottom")[18] = BUILD_CASTLE_MODEL.KOH2024RAMADAN
	SoraDGetChildByName(self, "Node_effect_bottom")[19] = BUILD_CASTLE_MODEL.DAGGER
	local SoraDGetChildByName(self, "Node_effect_bottom")[20], spcriDayModel = BUILD_CASTLE_MODEL.BUBBLE9TH, SoraDGetChildByName(self, "Node_effect_bottom")
	if SoraDisInList(self.model, spcriDayModel) and self.Node_criSp then
		self.Node_criSp:setVisible(true)
	end
end
function mainCityCastleSkin:setNightStyle()
	if self.Node_effect then
		self.Node_effect:setVisible(false)
	end
	if self.spine then
		self.spine:setAnimation(0, self.info.spineInfo.nightModel, true)
	end
	if self.spine_flag then
		for k, v in ipairs(self.spine_flag) do
			v:stopAllActions()
			v:setAnimation(0, "wanshang", true)
		end
	end
	if self.model == BUILD_CASTLE_MODEL.REDGEM then
		if SoraDGetChildByName(self, "Node_gem") then
			SoraDGetChildByName(self, "Node_gem"):setVisible(false)
		end
		if SoraDGetChildByName(self, "Node_gemex") then
			SoraDGetChildByName(self, "Node_gemex"):setVisible(false)
		end
		if self.Node_spine then
			self.Node_spine:setVisible(false)
		end
	end
	if self.model == BUILD_CASTLE_MODEL.FOURTH and SoraDGetChildByName(self, "dh_part_4") then
		SoraDGetChildByName(self, "dh_part_4"):setVisible(false)
	end
	if self.model == BUILD_CASTLE_MODEL.CONSTRUCTED then
		local Node_shader = SoraDGetChildByName(self, "Node_shader")
		if Node_shader then
			Node_shader:setVisible(false)
		end
		local Node_shader_bg = SoraDGetChildByName(self, "Node_shader_bg")
		if Node_shader_bg then
			Node_shader_bg:setVisible(false)
		end
	end
	if self.model == BUILD_CASTLE_MODEL.GOLDENCITY and SoraDGetChildByName(self, "Node_top_effect") then
		SoraDGetChildByName(self, "Node_top_effect"):setVisible(false)
	end
	if self.model == BUILD_CASTLE_MODEL.KOH2021RAMADAN and SoraDGetChildByName(self, "Node_top_effect") then
		SoraDGetChildByName(self, "Node_top_effect"):setVisible(false)
	end
	if self.model == BUILD_CASTLE_MODEL.THUNDERCLOUD then
		local Node_effect_bottom = SoraDGetChildByName(self, "Node_effect_bottom")
		if Node_effect_bottom then
			Node_effect_bottom:setVisible(false)
		end
		local Node_effect_top = SoraDGetChildByName(self, "Node_effect_top")
		if Node_effect_top then
			Node_effect_top:setVisible(false)
		end
	end
	_UPVALUE18_ = Node_effect_bottom
	SoraDGetChildByName(self, "Node_effect_bottom")[1] = BUILD_CASTLE_MODEL.CORBAN2021
	SoraDGetChildByName(self, "Node_effect_bottom")[2] = BUILD_CASTLE_MODEL.ICEWOLF
	SoraDGetChildByName(self, "Node_effect_bottom")[3] = BUILD_CASTLE_MODEL.KOH2022RAMADAN
	SoraDGetChildByName(self, "Node_effect_bottom")[4] = BUILD_CASTLE_MODEL.BYZANTINE
	SoraDGetChildByName(self, "Node_effect_bottom")[5] = BUILD_CASTLE_MODEL.CORBAN2022
	SoraDGetChildByName(self, "Node_effect_bottom")[6] = BUILD_CASTLE_MODEL.SEVENTH
	SoraDGetChildByName(self, "Node_effect_bottom")[7] = BUILD_CASTLE_MODEL.STARKING
	SoraDGetChildByName(self, "Node_effect_bottom")[8] = BUILD_CASTLE_MODEL.KINGSTARBATTLE
	SoraDGetChildByName(self, "Node_effect_bottom")[9] = BUILD_CASTLE_MODEL.FOOTBALL
	SoraDGetChildByName(self, "Node_effect_bottom")[10] = BUILD_CASTLE_MODEL.ICEDRAGON
	SoraDGetChildByName(self, "Node_effect_bottom")[11] = BUILD_CASTLE_MODEL.KOH2023RAMADAN
	SoraDGetChildByName(self, "Node_effect_bottom")[12] = BUILD_CASTLE_MODEL.MUSICCASTLESENIOR
	SoraDGetChildByName(self, "Node_effect_bottom")[13] = BUILD_CASTLE_MODEL.MUSICCASTLENORMAL
	SoraDGetChildByName(self, "Node_effect_bottom")[14] = BUILD_CASTLE_MODEL.AFTERNOONDESSERT
	SoraDGetChildByName(self, "Node_effect_bottom")[15] = BUILD_CASTLE_MODEL.EIGHTH
	SoraDGetChildByName(self, "Node_effect_bottom")[16] = BUILD_CASTLE_MODEL.ICECASTLE2023
	SoraDGetChildByName(self, "Node_effect_bottom")[17] = BUILD_CASTLE_MODEL.ALLSTARSHIP
	SoraDGetChildByName(self, "Node_effect_bottom")[18] = BUILD_CASTLE_MODEL.KOH2024RAMADAN
	SoraDGetChildByName(self, "Node_effect_bottom")[19] = BUILD_CASTLE_MODEL.DAGGER
	local SoraDGetChildByName(self, "Node_effect_bottom")[20], spcriNightModel = BUILD_CASTLE_MODEL.BUBBLE9TH, SoraDGetChildByName(self, "Node_effect_bottom")
	if SoraDisInList(self.model, spcriNightModel) and self.Node_criSp then
		self.Node_criSp:setVisible(false)
	end
end
function mainCityCastleSkin:checkSpecial()
	self.criSps, _ENV = nil, nil
	if self.model == BUILD_CASTLE_MODEL.HEGEMON and self.view then
		_ENV, self.spine_flag, _ENV = self.view, self.view, self.view
		self.view[1] = cc.p(2455, 1842)
		self.view[2] = cc.p(2539, 1799)
		self.view[3] = cc.p(2624, 1753)
		self.view[4] = cc.p(2560, 1894)
		self.view[5] = cc.p(2644, 1852)
		local _ENV, self.view[6], posArray = cc.p(2730, 1809), cc.p(2730, 1809), self.view
		cc.p(2730, 1809)[1] = cc.p(2317, 1634)
		cc.p(2730, 1809)[2] = cc.p(2400, 1591)
		cc.p(2730, 1809)[3] = cc.p(2486, 1549)
		cc.p(2730, 1809)[4] = cc.p(2414, 1684)
		cc.p(2730, 1809)[5] = cc.p(2498, 1642)
		local cc.p(2730, 1809)[6], posArray_bzt = cc.p(2584, 1599), cc.p(2730, 1809)
		for i = 1, 6 do
			local spine_flag = sp.SkeletonAnimation:create("spine/wanshengjieqigan.skel", "spine/wanshengjieqigan.atlas", 1)
			spine_flag:setPosition(posArray[i])
			if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
				spine_flag:setPosition(posArray_bzt[i])
			end
			spine_flag:addTo(self.view)
			spine_flag:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.other)
			spine_flag:setAnimation(0, "baitian", true)
			self.spine_flag[i] = spine_flag
		end
	end
	if self.model == BUILD_CASTLE_MODEL.FOURTH and self.view then
		local Node_shader_bottom = SoraDGetChildByName(self, "Node_shader_bottom")
		local Node_shader_top = SoraDGetChildByName(self, "Node_shader_top")
		_UPVALUE2_ = self
		_UPVALUE3_, self[1] = "yun", "yun"
		local _UPVALUE3_, self[2], bottomKey = "yun", "pubu6", self
		;("yun")[1] = "pubu4"
		;("yun")[2] = "liushui1"
		local ("yun")[3], topKey = "liushui2", "yun"
		for k, v in pairs(mainCityDefine.castleFourthCfg) do
			if SoraDisInList(k, bottomKey) then
				self:createShaderEffect(v, Node_shader_bottom)
			elseif SoraDisInList(k, topKey) then
				self:createShaderEffect(v, Node_shader_top)
			end
		end
	end
	if self.model == BUILD_CASTLE_MODEL.KINGLION and self.view then
		local Node_shader = SoraDGetChildByName(self, "Node_shader")
		for k, v in pairs(mainCityDefine.castleLionCfg) do
			self:createShaderEffect(v, Node_shader)
		end
	end
	if self.model == BUILD_CASTLE_MODEL.SKYGUARD and self.view then
		local Node_shader_bottom = SoraDGetChildByName(self, "Node_shader_bottom")
		local Node_shader_top = SoraDGetChildByName(self, "Node_shader_top")
		_UPVALUE3_ = self
		_UPVALUE2_, self[1] = "ball", "ball"
		_UPVALUE2_, self[2] = "ball", "ball1"
		local _UPVALUE2_, self[3], bottomKey = "ball", "ball2", self
		;("ball")[1] = "pubu1"
		local ("ball")[2], topKey = "tkwsshiwang", "ball"
		for k, v in pairs(mainCityDefine.castleGuardCfg) do
			if SoraDisInList(k, bottomKey) then
				self:createShaderEffect(v, Node_shader_bottom)
			elseif SoraDisInList(k, topKey) then
				self:createShaderEffect(v, Node_shader_top)
			end
		end
	end
	if self.model == BUILD_CASTLE_MODEL.KOH2020RAMADAN and self.view then
		local Node_shader_bottom = SoraDGetChildByName(self, "Node_shader_bottom")
		local Node_shader_top = SoraDGetChildByName(self, "Node_shader_top")
		mainCityDefine = self
		local _UPVALUE3_, self[1], bottomKey = "water", "water", self
		;("water")[1] = "lg"
		;("water")[2] = "xz1"
		local ("water")[3], topKey = "xz3", "water"
		for k, v in pairs(mainCityDefine.castle2020RamadanCfg) do
			if SoraDisInList(k, bottomKey) then
				self:createShaderEffect(v, Node_shader_bottom)
			elseif SoraDisInList(k, topKey) then
				self:createShaderEffect(v, Node_shader_top)
			end
		end
	end
	if self.model == BUILD_CASTLE_MODEL.CONSTRUCTED and self.view then
		local Node_shader_bg = SoraDGetChildByName(self, "Node_shader_bg")
		mainCityDefine = self
		local self[1], shaderBgArray = "jd_xw1", self
		for k, v in pairs(mainCityDefine.castleConstructedCfg) do
			if SoraDisInList(k, shaderBgArray) then
				self:createShaderEffect(v, Node_shader_bg)
			end
		end
		local Node_shader = SoraDGetChildByName(self, "Node_shader")
		_UPVALUE2_ = self
		self[1] = "jd_xw2"
		local self[2], shaderArray = "jd_xw3", self
		for k, v in pairs(mainCityDefine.castleConstructedCfg) do
			if SoraDisInList(k, shaderArray) then
				self:createShaderEffect(v, Node_shader)
			end
		end
	end
	if self.model == BUILD_CASTLE_MODEL.GOLDENCITY and self.view then
		local Node_top_effect = SoraDGetChildByName(self, "Node_top_effect")
		local et_actNode = SoraDCreatAnimation("animationCastle45Effect")
		et_actNode:addTo(Node_top_effect)
	end
	if self.model == BUILD_CASTLE_MODEL.CORBAN2021 and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb1 = cc.criSprite.createCriSprite("G_2021kafeicb1.usm", false, true)
		criSp_cb1:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb1)
		criSp_cb1:addTo(Node_criSp, 1)
		criSp_cb1:setPosition(-5, 75)
		criSp_cb1:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		local criSp_cb2 = cc.criSprite.createCriSprite("2021kafeicb2.usm", false, true)
		criSp_cb2:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb2)
		criSp_cb2:addTo(Node_criSp, 0)
		criSp_cb2:setPosition(-5, 75)
		criSp_cb2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	end
	if self.model == BUILD_CASTLE_MODEL.THUNDERCLOUD and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("sp_shcbzb_001.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-10, -239)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	end
	if self.model == BUILD_CASTLE_MODEL.HOURGLASS and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		if IsArClient then
			local criSp_cb1 = cc.criSprite.createCriSprite("G_liuzhouniancb_011.usm", false, true)
			criSp_cb1:setIsCheckVisibleInScreen(true)
			table.insert(self.criSps, criSp_cb1)
			criSp_cb1:addTo(Node_criSp, 1)
			criSp_cb1:setPosition(-10, 0)
			criSp_cb1:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		else
			local criSp_cb1 = cc.criSprite.createCriSprite("G_liuzhounianros_01.usm", false, true)
			criSp_cb1:setIsCheckVisibleInScreen(true)
			table.insert(self.criSps, criSp_cb1)
			criSp_cb1:addTo(Node_criSp, 1)
			criSp_cb1:setPosition(0, -10)
			criSp_cb1:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		end
		if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
			local criSp_cb2 = cc.criSprite.createCriSprite("liuzhounianros_01.usm", false, true)
			criSp_cb2:setIsCheckVisibleInScreen(true)
			table.insert(self.criSps, criSp_cb2)
			criSp_cb2:addTo(Node_criSp, 0)
			criSp_cb2:setPosition(-8, -315)
			criSp_cb2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		else
			local criSp_cb2 = cc.criSprite.createCriSprite("liuzhouniancb_011.usm", false, true)
			criSp_cb2:setIsCheckVisibleInScreen(true)
			table.insert(self.criSps, criSp_cb2)
			criSp_cb2:addTo(Node_criSp, 0)
			criSp_cb2:setPosition(-8, -315)
			criSp_cb2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		end
	end
	if self.model == BUILD_CASTLE_MODEL.ICEWOLF and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_bingxuecb_01.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-30, -45)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.KOH2022RAMADAN and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_2022zhaiyuecb.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(0, 80)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.BYZANTINE and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_baizhantingcb.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(0, 0)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.CORBAN2022 and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_2022zaishengjiecb.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-43, 40)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.SEVENTH and self.view then
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
	if self.model == BUILD_CASTLE_MODEL.STARKING and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_xingchencb_01.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-50, -40)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.KINGSTARBATTLE and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_xingchenwangzuo_01.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-20, 90)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.FOOTBALL and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_2022shijiebeicb.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-80, 50)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.ICEDRAGON and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_jianianhuacb2022_01.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(60, 30)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.KOH2023RAMADAN and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_2023zhaiyuecb_bt.usm", false, true)
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
	if self.model == BUILD_CASTLE_MODEL.MUSICCASTLESENIOR and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_yqzwcbzb_hhb.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-50, 139)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.MUSICCASTLENORMAL and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_yqzwcbzb_ptb.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-70, 32)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.AFTERNOONDESSERT and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_zaishengjiecb23.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp, 1)
		criSp_cb:setPosition(-60, 38)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		local criSp_cb1 = cc.criSprite.createCriSprite("zaishengjiecb23_01.usm", false, true)
		criSp_cb1:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb1)
		criSp_cb1:addTo(Node_criSp, 2)
		criSp_cb1:setPosition(-60, 38)
		criSp_cb1:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	end
	if self.model == BUILD_CASTLE_MODEL.EIGHTH and self.view then
		local Node_criSpCenter = SoraDGetChildByName(self, "Node_criSpCenter")
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("feichuancb_ty.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSpCenter, 1)
		criSp_cb:setPosition(-475, 56)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		local criSp_cb2 = cc.criSprite.createCriSprite("G_feichuancb_bt.usm", false, true)
		criSp_cb2:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb2)
		criSp_cb2:addTo(Node_criSp, 1)
		criSp_cb2:setPosition(-223, 103)
		criSp_cb2:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.ICECASTLE2023 and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("BXJCB_BT.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp, 1)
		criSp_cb:setPosition(169, -61)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		local criSp_cb2 = cc.criSprite.createCriSprite("G_BXJCB_BT.usm", false, true)
		criSp_cb2:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb2)
		criSp_cb2:addTo(Node_criSp, 2)
		criSp_cb2:setPosition(169, -61)
		criSp_cb2:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.ALLSTARSHIP and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("qmx_cb_nc_bt.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-65, -105)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		local Node_criSp_bg = SoraDGetChildByName(self, "Node_criSp_bg")
		local criSp_cbbg = cc.criSprite.createCriSprite("qmx_cbbg_nc_bt.usm", false, true)
		criSp_cbbg:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cbbg)
		criSp_cbbg:addTo(Node_criSp_bg)
		criSp_cbbg:setPosition(-196, -260)
		criSp_cbbg:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	end
	if self.model == BUILD_CASTLE_MODEL.KOH2024RAMADAN and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("castleSkinNight_68.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(60.4, -250)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	end
	if self.model == BUILD_CASTLE_MODEL.DAGGER and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("G_castleSkin_69.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(2, -58)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
	if self.model == BUILD_CASTLE_MODEL.BUBBLE9TH and self.view then
		local Node_criSp = SoraDGetChildByName(self, "Node_criSp")
		local criSp_cb = cc.criSprite.createCriSprite("castleSkin_70.usm", false, true)
		criSp_cb:setIsCheckVisibleInScreen(true)
		table.insert(self.criSps, criSp_cb)
		criSp_cb:addTo(Node_criSp)
		criSp_cb:setPosition(-10, -90)
		criSp_cb:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	end
end
function mainCityCastleSkin:createShaderEffect(cfg, target)
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
function mainCityCastleSkin:removeRelation()
	if self.view and self.spine_flag then
		for k, v in ipairs(self.spine_flag) do
			self.spine_flag[k]:removeFromParent()
			self.spine_flag[k] = nil
		end
		self.spine_flag = nil
	end
end
return mainCityCastleSkin
