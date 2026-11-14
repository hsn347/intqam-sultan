local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local GROU_ID = worldMapDefine.GROU_ID
local worldMapNewTrialCity = class("worldMapNewTrialCity", function()
	local target = include("worldMapInstance").new("worldMapNewTrialCity")
	return target
end)
function worldMapNewTrialCity:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapNewTrialCity:_initUI()
	self.baseImage = display.newSprite("#paotai_base.png")
	self.baseImage:setPosition(cc.p(0, 30))
	self:addChild(self.baseImage, -1)
	self.modelImage = display.newSprite("#Map_King_castle_01.png")
	self.modelImage:setAnchorPoint(cc.p(0.52, 0.39))
	self:addChild(self.modelImage, -1)
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(2.0)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 70))
	self.image_Protect:addTo(self, 1)
	self.image_name = display.newSprite("#frame_map_07.png")
	self.image_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 140))
	self.image_name:addTo(self, 3)
	self.image_name:setGroupID(GROU_ID.group_level_build)
	self.image_name:setScaleX(1.5)
	_ENV = self.image_name
	self.image_name.UILabelType = 2
	self.image_name.text = ""
	self.image_name.size = 20
	self.text_Name = SoraDCreateLabel(self.image_name)
	self.text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 142))
	self.text_Name:setColor(cc.c3b(200, 200, 200))
	self.text_Name:addTo(self, 4)
	self.text_Name:setGroupID(GROU_ID.group_text)
end
function worldMapNewTrialCity:_initData(...)
	self.warStatus = gKingdomWarStatusType.close
	self.isNpc = true
	self.cityState = gMapObjStateTypeDef.gMapObjStateTypeFree
end
function worldMapNewTrialCity:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_SHOW_BUILD_TIPS", handler(self, self.onShowBuildTips))
end
function worldMapNewTrialCity:setBatchNodeGroupID(groupID)
	self.modelImage:setGroupID(groupID)
end
function worldMapNewTrialCity:initInstanceData(objData)
	self:updateData(objData)
	self:updateModel()
end
function worldMapNewTrialCity:updateData(data)
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.isNpc ~= nil then
		self.isNpc = data.isNpc
	end
	if data.status then
		self.cityState = data.status
	end
	if data.cityDefense then
		self.cityDefense = data.cityDefense
	end
	if data.army then
		self.army = data.army
	end
	self:refreshData()
	self:updateSafeState()
end
function worldMapNewTrialCity:updateModel()
	self.baseImage:setVisible(false)
	self.modelImage:setSpriteFrame("map_devilValley_wall_01.png")
	self.modelImage:setAnchorPoint(cc.p(0.6, 0.4))
	self.modelImage:setPosition(cc.p(-60, 15))
	self.image_Protect:setScale(2.0)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 70))
end
function worldMapNewTrialCity:updateSafeState()
	if self.warStatus == gKingdomWarStatusType.inWar then
		self.image_Protect:setVisible(false)
	else
		self.image_Protect:setVisible(true)
	end
end
function worldMapNewTrialCity:refreshData(...)
	if self.isNpc then
		self.text_Name:setColor(cc.c3b(200, 0, 0))
		self.text_Name:setString(i18n("devilvalley_text_22"))
	else
		self.text_Name:setColor(cc.c3b(200, 200, 200))
		self.text_Name:setString(i18n("devilvalley_text_21"))
	end
end
function worldMapNewTrialCity:updateCityState()
	self:updateFireEffect(self.cityState)
end
function worldMapNewTrialCity:getInstanceOp()
	local _ENV, buttonTypeArray
	if self.warStatus ~= gKingdomWarStatusType.inWar then
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
		table.insert(buttonTypeArray, nil)
	else
		_ENV = nil
		_ENV, (nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi, worldMapDefine.worldMapTipButtonType_gongJi
		;(nil).extra, worldMapDefine.worldMapTipButtonType_gongJi.dispatchType = worldMapDefine.worldMapTipButtonType_gongJi, worldMapDefine.worldMapTipButtonType_zhanLing
		table.insert(buttonTypeArray, nil)
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
		table.insert(buttonTypeArray, nil)
		local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
		if haveHall then
			_ENV = 0
			;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
			table.insert(buttonTypeArray, 0)
		end
	end
	return buttonTypeArray
end
function worldMapNewTrialCity:getSiteClassID()
	return _G.gMapNewTrialBuildType.subMapTypeDVWCastle
end
return worldMapNewTrialCity
