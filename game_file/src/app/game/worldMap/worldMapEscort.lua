local worldMapEscort = class("worldMapEscort", function(target)
	local target = include("worldMapInstance").new("worldMapEscort")
	return target
end)
function worldMapEscort:ctor()
	self.bgImage = display.newSpriteNoChild("#Map_build_escort.png")
	self:addChild(self.bgImage, -1)
	self:_initData()
end
function worldMapEscort:_initData()
	self.isSelfIn = false
end
function worldMapEscort:setBatchNodeGroupID(groupID)
	self.bgImage:setGroupID(groupID)
end
function worldMapEscort:initInstanceData(escortData)
	self:updateData(escortData)
end
function worldMapEscort:updateData(data)
	if not data then
		return
	end
	self.isSelfIn = data.isSelfIn or false
end
function worldMapEscort:getFavoriteName()
	local favoriteName = self.playerName
	return favoriteName
end
function worldMapEscort:onClickInstance(onShowView)
	local allianceDesRead = include("allianceDesRead")
	if allianceDesRead.getPlayerConquestWarMigration() then
		return
	end
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
	local escortCtrl = gametop.playertop_:getModule("escortCtrl")
	local minLv = escortCtrl.dataMgr:getEscortCityLevelMin()
	if minLv > tonumber(castleBcell.info.lv) then
		SoraDShowMsgTip(i18n("common_text_2483"), "#icon_escort_convey.png")
		return
	end
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	if not activityShowCtrl:isActivityOpen(gActivityTimeActivityID.ESCORT) then
		SoraDShowMsgTip(i18n("common_text_2486"), "#icon_escort_convey.png")
		return
	end
	self:playClickSound()
	return self:onShowWorldMapTip(onShowView)
end
function worldMapEscort:playClickSound()
	SoraDPlaySound("worldmap", 5)
end
function worldMapEscort.req4escort(...)
	local sendServer2Find = function(...)
		local gametop = gModuleMgr.getObject("gametop")
		local escortCtrl = gametop.playertop_:getModule("escortCtrl")
		escortCtrl:reqGetClosestBuild()
		SoraDShowLoading()
	end
	local local2Find = function(_fun)
		SoraDShowLoading()
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local _pos = cityCtrl:getCurCityPos()
		_ENV = nil
		;(nil).point = _pos
		local worldObj = SoraDGetClosestInstanceInWorldMap(gMapObjTypeDef.mapObjTypeEscort, false, false, nil)
		if worldObj then
			local showTilePoint = worldObj:getTilePoint()
			SoraDGotoWorldMapPoint(showTilePoint, true)
			SoraDCloseLoading()
			SoraDRemoveAllPanelFromManager()
		else
			_fun()
		end
	end
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
	local escortCtrl = gametop.playertop_:getModule("escortCtrl")
	local minLv = escortCtrl.dataMgr:getEscortCityLevelMin()
	if minLv > tonumber(castleBcell.info.lv) then
		SoraDShowMsgTip(i18n("common_text_2483"), "#icon_escort_convey.png")
	else
		local2Find(sendServer2Find)
	end
end
function worldMapEscort:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	if isSelfKindom then
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_yayun
		table.insert(buttonTypeArray, nil)
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_tuijianlueduo
		table.insert(buttonTypeArray, nil)
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_junqing
		table.insert(buttonTypeArray, nil)
	else
	end
	_ENV = nil
	;(nil).buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
	table.insert(buttonTypeArray, nil)
	return buttonTypeArray
end
return worldMapEscort
