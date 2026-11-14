local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local roaringFlameWarInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameWorldMap/roaringFlameWarInfo", roaringFlameWarInfo)
function roaringFlameWarInfo:onInit()
	self.objList, _ENV, self.palaceSubType = gWorldTypeServerDef.subTypeRoaringFlameWarPalace, gWorldTypeServerDef.subTypeRoaringFlameWarPalace, gWorldTypeServerDef.subTypeRoaringFlameWarPalace
	self.isDirty = false
	self.isClick = false
	_ENV = nil
	;(nil).time = ""
	self.fields.Text_remain:setString(i18n("flames_dunes_text162", nil))
	self.fields.Button_build:addClickListener(handler(self, self.onClickBtnBuild))
	local buildName = roaringFlameWarRead.getBuildName(self.palaceSubType)
	self.fields.Text_buildName:setString(buildName)
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	local Sprite_go = self.fields.Button_go:getChild("icon")
	_UPVALUE2_ = handler(self, self.onClickBtnGo)
	handler(self, self.onClickBtnGo)[1] = ffa.scaleTo(0.5, 0.8)
	handler(self, self.onClickBtnGo)[2] = ffa.scaleTo(1.0, 1.2)
	handler(self, self.onClickBtnGo)[3] = ffa.scaleTo(0.5, 1.0)
	handler(self, self.onClickBtnGo)[4] = ffa.scaleTo(0.5, 1.0)
	handler(self, self.onClickBtnGo)[5] = ffa.scaleTo(0.5, 1.0)
	Sprite_go:runAction(ffa.repeatForever(ffa.seq(handler(self, self.onClickBtnGo))))
	Sprite_go:fix()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_arrow:addClickListener(handler(self, self.onClickBtnArrow))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.Button_go:fixChildrenPos()
		self.fields.Image_build:fix()
	end
end
function roaringFlameWarInfo:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_WARDATA", handler(self, self.onMsgUpdateWarData))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_OCCUPY_NOTIFY", handler(self, self.onMsgOccupyNotify))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.onMsgUpdateAllianceWar))
end
function roaringFlameWarInfo:onShow()
	self:onMsgUpdateWarData()
end
function roaringFlameWarInfo:updateQueuesData(...)
	if self.isDirty then
		self.isDirty = false
		local queuesData = roaringFlameWarUtil.getQueuesData()
		roaringFlameWarUtil = nil
		;(nil).val = #queuesData
		self.fields.Button_build:setString(i18n("flames_dunes_text164", nil))
	end
end
function roaringFlameWarInfo:initData(showUI)
	self.showUI = showUI
	self.isDirty = true
	self:updateQueuesData()
	self:updateVisible()
end
function roaringFlameWarInfo:onMsgUpdateWarData(...)
	local campCount = roaringFlameWarRead.getCampCount()
	self.objList, roaringFlameWarRead = nil, nil
	self.fields.List:setNumItems(campCount)
	self:updateWarTime()
	self:updateOccupyTime()
	self:updateVisible()
end
function roaringFlameWarInfo:onClickBtnBuild(...)
	SoraDPlaySound()
	uiManager:show("RoaringFlameWar_FightBuild")
end
function roaringFlameWarInfo:onClickBtnGo(...)
	SoraDPlaySound()
	local jumpPos = roaringFlameWarRead.getBuildCoordBySubType(self.palaceSubType)
	SoraDGotoWorldMapPoint(jumpPos, true)
end
function roaringFlameWarInfo:onItemRenderer(index, obj)
	local camp = index + 1
	obj:initCamp(camp)
	self.objList[camp] = obj
end
function roaringFlameWarInfo:updateOccupyTime(...)
	for __, obj in pairs(self.objList) do
		obj:updateOccupyTime()
	end
	self:updateCampData()
end
function roaringFlameWarInfo:updateWarTime(...)
	if roaringFlameWarCtrl:checkInWarStatus() then
		local remainTime = roaringFlameWarUtil.getWarStateRemainTime()
		self.fields.Label_time:beginTime(remainTime)
	end
end
function roaringFlameWarInfo:updateVisible(...)
	if self.showUI and roaringFlameWarCtrl:checkInWarStatus() then
		self:setVisible(true)
	else
		self:setVisible(false)
	end
end
function roaringFlameWarInfo:onMsgOccupyNotify(target, event)
	self:updateTimeHandler()
	local subType = event.subType
	local notifyType = event.notifyType
	if subType ~= gWorldTypeServerDef.subTypeRoaringFlameWarPalace then
		return
	end
	if notifyType == "setCampOccupyPalaceSecs" then
		local camp = event.camp
		local obj = self.objList[camp]
		obj:updateOccupyTime()
		self:updateCampData()
	elseif notifyType == "setWarBuildingOwner" then
		self:updateOccupyTime()
	end
end
function roaringFlameWarInfo:onMsgUpdateAllianceWar(target, event)
	if event.type and event.type ~= GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR then
		return
	end
	self:updateTimeHandler()
end
function roaringFlameWarInfo:updateTimeHandler(...)
	self.isDirty = true
	if not self.timeHandler then
		self:updateTime()
		self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
	end
end
function roaringFlameWarInfo:updateTime(...)
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
	self:updateQueuesData()
end
function roaringFlameWarInfo:onClickBtnArrow(...)
	SoraDPlaySound()
	if not self.isClick then
		local objId = roaringFlameWarUtil.getPalaceBuildID()
		if not roaringFlameWarUtil.checkBuildOpenTime(objId) then
			SoraDShowMsgTip(i18n("flames_dunes_text230"))
			self.controllers.c1:setSelectedIndex(0)
			return
		end
		self:updateOccupyTime()
	end
	self.isClick = not self.isClick
end
function roaringFlameWarInfo:getCampData(...)
	local _ENV, campData
	for __, obj in pairs(self.objList) do
		local occupyTime = obj:getOccupyTime()
		local camp = obj:getCamp()
		_ENV = nil
		;(nil).camp = camp
		;(nil).occupyTime = occupyTime
		;(nil).occupyPalaceEndTime = roaringFlameWarCtrl:getOccupyPalaceEndTime(camp)
		table.insert(campData, nil)
	end
	_UPVALUE2_, _UPVALUE3_ = nil, pairs(self.objList)
	_UPVALUE2_, (nil)[1] = "occupyTime", "occupyTime"
	_UPVALUE2_, (nil)[2] = "occupyTime", ">"
	_UPVALUE2_, ("occupyTime")[1] = "occupyPalaceEndTime", "occupyPalaceEndTime"
	_UPVALUE2_, ("occupyTime")[2] = "occupyPalaceEndTime", "<"
	;("occupyPalaceEndTime")[1] = "camp"
	;("occupyPalaceEndTime")[2] = "<"
	pairs(self.objList)[1] = nil
	pairs(self.objList)[2] = "occupyTime"
	pairs(self.objList)[3] = "occupyPalaceEndTime"
	serviceFunctions.sort(campData, pairs(self.objList))
	return campData
end
function roaringFlameWarInfo:updateCampData()
	local campData = self:getCampData()
	self.campData = campData
	local campCount = #campData
	local objH = self.objList[1]:getHeight()
	for i, v in ipairs(campData) do
		local obj = self.objList[v.camp]
		local posY = (i - 1) * objH
		obj:stopAllActions()
		obj:runAction(ffa.moveTo(0.5, obj:getPositionX(), posY))
	end
	local owner = roaringFlameWarUtil.getPalaceOwner()
	local ownerCamp = owner and owner.camp
	if ownerCamp and ownerCamp ~= campData[1].camp then
		if not self.timeHandler2 then
			self.timeHandler2 = SoradCreateTimer(self, handler(self, self.updateTime2))
		end
	elseif self.timeHandler2 then
		SoraDManagerRemoveTimer(self, self.timeHandler2)
		self.timeHandler2 = nil
	end
end
function roaringFlameWarInfo:updateTime2(...)
	print("==roaringFlameWarInfo:updateTime2===")
	local campData = self:getCampData()
	for i, v in ipairs(campData) do
		if self.campData[i].camp ~= v.camp then
			self:updateCampData()
			break
		end
	end
end
return roaringFlameWarInfo
