_ENV = nil
_ENV, (nil).count_num = nil, 3
;(nil).screenWidth = 750
;(nil).safeAreaBottom = 300
_ENV, (nil).battleArea, (nil).safeAreaTop = nil, nil, 220
;(nil)[1] = cc.c4f(0, 0, 1, 1)
;(nil)[2] = cc.c4f(0, 1, 0, 1)
;(nil)[3] = cc.c4f(0, 1, 1, 1)
;(nil).debugColor, (nil)[4] = nil, cc.c4f(1, 0, 0, 1)
local _defaultParam
_defaultParam.battleArea.spawnX = -50
_defaultParam.battleArea.endX = _defaultParam.battleArea.spawnX + _defaultParam.battleArea.screenWidth
_defaultParam.battleArea.totalH = display.height - (_defaultParam.battleArea.safeAreaBottom + _defaultParam.battleArea.safeAreaTop)
_defaultParam.battleArea.singleH = _defaultParam.battleArea.totalH / 5
_defaultParam.battleArea.roadH, _ENV = _defaultParam.battleArea.totalH / 5, _defaultParam.battleArea.totalH / 5
for i = 1, 3 do
	_defaultParam.battleArea.roadH[i] = _defaultParam.battleArea.safeAreaBottom + _defaultParam.battleArea.totalH / 5 * (i - 1)
end
_defaultParam.battleArea.roadH[4] = _defaultParam.battleArea.safeAreaBottom + _defaultParam.battleArea.totalH / 5 * 4
local allianceHuntTestView = class("allianceHuntTestView", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("commonTestView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function allianceHuntTestView:ctor()
	self.isHideCurrentSceneView = true
	self:createUI()
	self.Top_Size_Tile_Image_bg = SoraDGetChildByName(self, "Top_Size_Tile_Image_bg")
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.commonFramTitle_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self:init()
end
function allianceHuntTestView:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function allianceHuntTestView:init(data)
	self.panel_pet = ccui.Layout:create()
	self.panel_pet:setAnchorPoint(cc.p(0.5, 0))
	self.panel_pet:setPosition(cc.p(320, 0))
	self.panel_pet:addTo(self, 0)
	self.panel_pet:setContentSize(cc.size(640, display.height - 150))
	self.panel_pet:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	self.panel_pet:setBackGroundColor(cc.c3b(128, 128, 128))
	self.panel_pet:setOpacity(120)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self:testBox()
end
function allianceHuntTestView:testBox()
	_ENV, self.preyAnimals, _ENV = nil, nil, nil
	;(nil).beginTime = 1730
	_ENV, (nil).generateIndex = nil, 8
	;(nil).arrowNum = 0
	;(nil).hp = 2
	;(nil).killPoint = 80
	;(nil).maxhp = 2
	;(nil).preyID = 1601
	;(nil).preyInfo, (nil).speed = nil, 50
	local (nil).roadIndex, spdata = 4, nil
	for i = 1, 5 do
		local newspdata = clone(spdata)
		newspdata.preyInfo.preyID = 1600 + (i - 1)
		local preyAnimal = include("allianceHuntPrey").new()
		preyAnimal:init(newspdata, _defaultParam.battleArea)
		preyAnimal:addTo(self, 10)
		preyAnimal:setPositionX(320)
		preyAnimal:setPositionY(100 + i * 100)
		preyAnimal:stopAllActions()
		table.insert(self.preyAnimals, preyAnimal)
	end
end
function allianceHuntTestView:hitTest(touchPoint)
	for i, v in ipairs(self.preyAnimals) do
		v:hitTest(touchPoint)
	end
end
function allianceHuntTestView:onLayoutItem(target, event)
	if event == ccui.TouchEventType.ended then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.began then
		local touchBeganPoint = target:getTouchBeganPosition()
		self:hitTest(touchBeganPoint)
	end
end
return allianceHuntTestView
