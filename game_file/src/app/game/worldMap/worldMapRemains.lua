local gametop = gModuleMgr.getObject("gametop")
local worldMapRemains = class("worldMapRemains", function(target)
	local target = include("worldMapInstance").new("worldMapRemains")
	return target
end)
function worldMapRemains:ctor()
	self.bgImage = display.newSpriteNoChild("#Map_build_relic.png")
	self:addChild(self.bgImage, -1)
	self:_initData()
end
function worldMapRemains:_initData()
	self.romanSoulEffectNode = nil
	self.isHaveRomanSoul = false
end
function worldMapRemains:addCacheBefore()
	if self.romanSoulEffectNode then
		self.romanSoulEffectNode:removeFromParent()
		self.romanSoulEffectNode = nil
	end
end
function worldMapRemains:setBatchNodeGroupID(groupID)
	self.bgImage:setGroupID(groupID)
end
function worldMapRemains:initInstanceData(remainsData)
	self:updateData(remainsData)
end
function worldMapRemains:updateData(data)
	if not data then
		return
	end
	self.isHaveRomanSoul = data.isHaveRomanSoul or false
	self:showRomanSoulEffect(self.isHaveRomanSoul)
end
function worldMapRemains:showRomanSoulEffect(show)
	if show then
		if not self.romanSoulEffectNode then
			_ENV, _ENV = nil, self.romanSoulEffectNode
			_ENV, (nil).plist = nil, "et_yijichub_display_01.plist"
			;(nil).x = 5.4
			;(nil).scale, (nil).y = nil, 5.52
			_ENV, self.romanSoulEffectNode[1], (nil).rotate = nil, nil, -8.34
			_ENV, (nil).plist = nil, "et_yijichub_display_02.plist"
			;(nil).x = 7
			self.romanSoulEffectNode[2], (nil).scale, (nil).y = nil, nil, 7.3
			local param = self.romanSoulEffectNode
			self.romanSoulEffectNode = SoraDCreateEffectNode(param)
			self.romanSoulEffectNode:addTo(self, 2)
		end
	elseif self.romanSoulEffectNode then
		self.romanSoulEffectNode:removeFromParent()
		self.romanSoulEffectNode = nil
	end
end
function worldMapRemains:onClickInstance(onShowView)
	self:playClickSound()
	local myKindomID = gametop.playertop_:getMapID()
	local isSelfKindom = myKindomID == self.kingdomID
	if isSelfKindom then
		local isSelfIn = self:checkIsSelfIn()
		if isSelfIn then
			uiManager:show("WorldMapRemains", self)
			return nil, false
		end
	end
	return self:onShowWorldMapTip(onShowView)
end
function worldMapRemains:playClickSound()
	SoraDPlaySound("worldmap", 7)
end
function worldMapRemains:checkIsSelfIn()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	if kingdomMapCtrl.kingdomMapCell:hasMyQueueToMapObj(self.instanceID, gMapMoveLineServerType.moveLineTypeRelicsExplore, gMapMoveLineStatusType.moveLineStatusTypeWorking) then
		return true
	end
end
function worldMapRemains:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	local isSelfIn = self:checkIsSelfIn()
	if isSelfKindom and isSelfIn then
	else
		if isSelfKindom then
			_ENV = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_tanXian
			table.insert(buttonTypeArray, nil)
			local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
			local isOpened = romeActivityCtrl:isOpenRomeActivity()
			if isOpened then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_luomaZhanhunLaixi
				table.insert(buttonTypeArray, nil)
			end
		end
		_ENV = table.insert
		table.insert.buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
		table.insert(buttonTypeArray, table.insert)
	end
	return buttonTypeArray
end
return worldMapRemains
