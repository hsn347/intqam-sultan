local worldMapViewDef = include("worldMapViewDef")
local manorCityRead = include("manorCityRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local worldMapComGarden = class("worldMapComGarden", include("worldMapCom"))
function worldMapComGarden:ctor()
	worldMapComGarden.super.ctor(self, "worldMapComGarden")
end
local Z_ORDER = worldMapDefine.Z_ORDER
local GROU_ID = worldMapDefine.GROU_ID
function worldMapComGarden:init()
	self.worldMapCell = self.target_.currentInMapViewCell
	self:initWidget()
end
function worldMapComGarden:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MAP_INIT", handler(self, self.onMsgMapInit))
	self:doReqestData()
	_ENV = self.doReqestData
	self.doReqestData.isHideCurrentSceneView = false
	local self.doReqestData.isHideMainUI, hideData = true, self.doReqestData
	SoraDHideCurrentSceneViewAndMainUI(hideData)
end
function worldMapComGarden:onExit()
	worldMapComGarden.super.onExit(self)
	worldMapComGarden = worldMapComGarden.super.onExit
	worldMapComGarden.super.onExit.isHideCurrentSceneView = false
	local worldMapComGarden.super.onExit.isHideMainUI, hideData = false, worldMapComGarden.super.onExit
	SoraDHideCurrentSceneViewAndMainUI(hideData)
end
function worldMapComGarden:doReqestData(...)
	print("==worldMapComGarden:doReqestData==")
	if worldMapDefine.isInGarden() then
		local selfUid = SoraDGetPlayerID()
		manorCityCtrl:reqGardenMapQueryMap(selfUid)
		manorCityCtrl:reqDressInit()
	end
	SoraDShowMsgTip(i18n("garden_text_54"))
end
function worldMapComGarden:initWidget(...)
	local btnMonsterSearch = SoraDGetChildByName(self.target_, "Button_monsterSearch")
	btnMonsterSearch:setVisible(false)
	local node = display.newNode()
	node:addTo(self.target_, Z_ORDER.topTipView)
	node:setPosition(0, 0)
	self.Node_war = node
	local obj = fguiHelper.createObject("ManorCity", "ManorWarUITop")
	obj:addTo(self.Node_war)
	obj:setPosition(0, -display.height)
	self.Node_top = obj
	local _fields = fguiHelper.get_fields(obj)
	_fields.Button_back:addClickListener(handler(self, self.onClickBtnBack))
	_fields.Button_visit:setString(i18n("garden_btn_05"))
	_fields.Button_visit:addClickListener(handler(self, self.onClickBtnVisit))
	if not SoraDFIsRA() then
		_fields.Button_visit:fixPos()
	end
	if worldMapDefine.isInGarden() then
		_fields.com_res:updateResource()
	else
		_fields.com_res:setVisible(false)
	end
	if userSDKManager.isDebug() then
		_fields.Button_cheat:setVisible(true)
		_fields.Button_cheat:setTitleText("作弊")
		_fields.Button_cheat:addClickListener(function()
			SoraDPlaySound()
			uiManager:show("CheatView")
		end)
	else
		_fields.Button_cheat:setVisible(false)
	end
	local obj = fguiHelper.createObject("ManorCity", "ManorUIBottom")
	obj:addTo(self.Node_war)
	obj:setPosition(0, -obj:getHeight())
	obj:setIsGardenWarUI(true)
	self.Node_bottom = obj
	self:initPremiumArea()
	self:fitNodeBottom()
end
function worldMapComGarden:fitNodeBottom()
	local fitHeight = 1136
	if fitHeight <= display.height then
		self.Node_war:setPositionY(display.iPhoneXBottom)
		return
	end
	local fitWidth = fitHeight / display.height * 640
	local fitScale = 640 / fitWidth
	self.Node_top:setWidth(fitWidth)
	self.Node_top:setScale(fitScale)
	self.Node_bottom:setWidth(fitWidth)
	self.Node_bottom:setScale(fitScale)
	self.Node_bottom:setPositionY(-self.Node_bottom:getHeight() * fitScale)
end
function worldMapComGarden:onMsgUpdateWarData(...)
end
function worldMapComGarden:onClickBtnBack(...)
	SoraDPlaySound()
	local manorCityUtil = include("manorCityUtil")
	manorCityUtil.outGardenWar()
end
function worldMapComGarden:onClickBtnVisit()
	SoraDPlaySound()
	self.pendingRandomVisit = true
	manorCityCtrl:reqGardenMapRandomVisit()
	SoraDShowLoading()
end
function worldMapComGarden:onMsgMapInit(target, event)
	if not self.pendingRandomVisit then
		return
	end
	self.pendingRandomVisit = false
	if not event or not event.player then
		local _ENV, player = event.player, event.player
	end
	if player.uid and player.uid ~= SoraDGetPlayerID() then
		local manorCityUtil = include("manorCityUtil")
		_ENV = nil
		;(nil).visitUid = player.uid
		manorCityUtil.gotoGardenCity(nil)
	end
end
function worldMapComGarden:initPremiumArea()
	local parentNode = display.newNode()
	parentNode:addTo(self.worldMapCell, Z_ORDER.tmxView)
	parentNode:setGroupID(GROU_ID.group_instance)
	parentNode:setGroupAuto(true)
	local vipAreaPosList = manorCityRead.getVipAreaPosList()
	for _, v1 in ipairs(vipAreaPosList) do
		local _node = display.newNode()
		_node:addTo(parentNode)
		local centerPos = v1.centerPos
		local tilePoint = centerPos
		local instancePoint = self.worldMapCell:getPointWithTile(tilePoint)
		_node:setPosition(instancePoint)
		local obj = fguiHelper.createObject("ManorWar", "ManorPremiumArea")
		obj:addTo(_node)
		local beginPos = v1.beginPos
		local villasPosList = manorCityRead.getVillasPosList()
		for _, v2 in ipairs(villasPosList) do
			local sprite = display.newSpriteNoChild("#Manor_Platform_01.png")
			sprite:addTo(parentNode)
			local tilePoint = cc.p(beginPos.x + v2.x + 0.5, beginPos.y + v2.y + 0.5)
			local instancePoint = self.worldMapCell:getPointWithTile(tilePoint)
			sprite:setPosition(instancePoint)
		end
	end
end
function worldMapComGarden:getGardenNodeTop()
	return self.Node_top
end
function worldMapComGarden:getGardenNodeBottom()
	return self.Node_bottom
end
function worldMapComGarden:exportMethods()
	_UPVALUE2_ = nil
	;(nil)[1] = "getGardenNodeTop"
	;(nil)[2] = "getGardenNodeBottom"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComGarden
