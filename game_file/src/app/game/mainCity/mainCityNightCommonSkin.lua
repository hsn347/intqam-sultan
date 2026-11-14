local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local mainCityDefine = include("mainCityDefine")
local mainCityFunctions = include("mainCityFunctions")
local cityBuildViewDef = include("cityBuildViewDef")
local mainCityNightCommonSkin = class("mainCityNightCommonSkin", function()
	if RAMADAN_SWITCH then
		return cc.CSLoader:createNode(getCCSPath("mainCityNightCommon"))
	else
		return cc.CSLoader:createNode(getCCSPath("mainCityNightCommon"))
	end
end)
function mainCityNightCommonSkin:ctor()
	self.Node_night_common = SoraDGetChildByName(self, "resoures")
	self:showLightAction()
end
function mainCityNightCommonSkin:setCastleModel(model)
	self.model = model
	self:checkSpecial()
end
function mainCityNightCommonSkin:showLightAction()
	math.randomseed(tostring(os.time()):reverse():sub(1, 7))
	local fadeIn = math.random(100, 150) / 100
	local fadeOut = math.random(80, 160) / 100
	local delay = math.random(50, 100) / 100
	for k, v in ipairs(self.Node_night_common:getChildren()) do
		v:setGroupID(mainCityDefine.CITY_TARGET_GROUPID.GROUP_NIGHT_COMMON)
		v:setLocalZOrder(k)
		_ENV = k
		k.fadeIn = fadeIn
		k.fadeOut = fadeOut
		k.delay = delay
		k.beginOpacity = 0.6
		k.endOpacity = 1
		SoraDFadeINOUT(v, k)
	end
end
function mainCityNightCommonSkin:checkSpecial()
	local dbLamp1 = SoraDGetChildByName(self, "dh_zhuchengilight19_33")
	if dbLamp1 then
		dbLamp1:setVisible(IsArClient)
	end
	local dbLamp2 = SoraDGetChildByName(self, "dh_zhuchengilight19_14")
	if dbLamp2 then
		dbLamp2:setVisible(IsArClient)
	end
	local cbLamp = SoraDGetChildByName(self, "dh_zhuchengilight19_29")
	_UPVALUE14_ = self
	self[1] = BUILD_CASTLE_MODEL.REDGEM
	self[2] = BUILD_CASTLE_MODEL.KINGLION
	self[3] = BUILD_CASTLE_MODEL.CONSTRUCTED
	self[4] = BUILD_CASTLE_MODEL.FIFTH
	self[5] = BUILD_CASTLE_MODEL.SOARCASTLE
	self[6] = BUILD_CASTLE_MODEL.THUNDERCLOUD
	self[7] = BUILD_CASTLE_MODEL.ICEWOLF
	self[8] = BUILD_CASTLE_MODEL.CORBAN2022
	self[9] = BUILD_CASTLE_MODEL.SEVENTH
	self[10] = BUILD_CASTLE_MODEL.STARKING
	self[11] = BUILD_CASTLE_MODEL.FOOTBALL
	self[12] = BUILD_CASTLE_MODEL.ICEDRAGON
	self[13] = BUILD_CASTLE_MODEL.KOH2023RAMADAN
	local self[14], spBehand = BUILD_CASTLE_MODEL.AFTERNOONDESSERT, self
	if cbLamp and SoraDisInList(self.model, spBehand) then
		cbLamp:setVisible(false)
	end
	local cbbgtopLamp = SoraDGetChildByName(self, "dh_zhuchengilight19_28")
	_UPVALUE12_ = self
	self[1] = BUILD_CASTLE_MODEL.CONSTRUCTED
	self[2] = BUILD_CASTLE_MODEL.FIFTH
	self[3] = BUILD_CASTLE_MODEL.GOLDENCITY
	self[4] = BUILD_CASTLE_MODEL.THUNDERCLOUD
	self[5] = BUILD_CASTLE_MODEL.ICEWOLF
	self[6] = BUILD_CASTLE_MODEL.CORBAN2022
	self[7] = BUILD_CASTLE_MODEL.SEVENTH
	self[8] = BUILD_CASTLE_MODEL.STARKING
	self[9] = BUILD_CASTLE_MODEL.FOOTBALL
	self[10] = BUILD_CASTLE_MODEL.ICEDRAGON
	self[11] = BUILD_CASTLE_MODEL.KOH2023RAMADAN
	local self[12], spHead = BUILD_CASTLE_MODEL.AFTERNOONDESSERT, self
	if cbbgtopLamp and SoraDisInList(self.model, spHead) then
		cbbgtopLamp:setVisible(false)
	end
	local cbbLamp = SoraDGetChildByName(self, "dh_zhuchengilight19_19")
	_UPVALUE13_ = self
	self[1] = BUILD_CASTLE_MODEL.KINGLION
	self[2] = BUILD_CASTLE_MODEL.ICECASTLE
	self[3] = BUILD_CASTLE_MODEL.HOURGLASS
	self[4] = BUILD_CASTLE_MODEL.ICEWOLF
	self[5] = BUILD_CASTLE_MODEL.CORBAN2022
	self[6] = BUILD_CASTLE_MODEL.STARKING
	self[7] = BUILD_CASTLE_MODEL.KINGSTARBATTLE
	self[8] = BUILD_CASTLE_MODEL.FOOTBALL
	self[9] = BUILD_CASTLE_MODEL.ICEDRAGON
	self[10] = BUILD_CASTLE_MODEL.KOH2023RAMADAN
	self[11] = BUILD_CASTLE_MODEL.MUSICCASTLESENIOR
	self[12] = BUILD_CASTLE_MODEL.MUSICCASTLENORMAL
	local self[13], spWall = BUILD_CASTLE_MODEL.AFTERNOONDESSERT, self
	if cbbLamp and SoraDisInList(self.model, spWall) then
		cbbLamp:setVisible(false)
	end
	local cwgLight = SoraDGetChildByName(self, "dh_chongwuguan_40")
	if cwgLight then
		cwgLight:setVisible(IsArClient)
	end
	local river = SoraDGetChildByName(self, "dh_zhuchengilight19_12")
	if river then
		river:setVisible(not SoraDIsBraveOpen())
	end
	local staues = SoraDGetChildByName(self, "dh_zhuchengilight19_36")
	if staues then
		staues:setVisible(SoraDIsBraveOpen())
	end
	local showGardenLight = commonCheck.GARDEN
	local light1 = SoraDGetChildByName(self, "dh_zhuchengilight_1")
	if light1 then
		light1:setVisible(showGardenLight)
	end
	local light1_ROS = SoraDGetChildByName(self, "dh_zhuchengilight_1_ROS")
	if light1_ROS then
		light1_ROS:setVisible(not showGardenLight)
	end
end
return mainCityNightCommonSkin
