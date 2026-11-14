local _ENV, commonForwardFunc
local _ENV, _ENV, funcDef
local (nil).default, funcCfg = "forwardToCommon", nil
function commonForwardFunc.forwardTo(targetData)
	local targetType = targetData.forwardType or "default"
	local func = funcCfg[targetType]
	if func and commonForwardFunc[func] then
		commonForwardFunc[func](targetData)
	end
end
function commonForwardFunc.forwardToCommon(targetPanel, params)
	local panel = SoraDCreatePanel(targetPanel)
	if panel then
		panel:show(unpack(params))
	end
end
function commonForwardFunc.forwardToBuildUpgrade(params)
	local buildLogic = include("buildLogic")
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local buildCellTbl = cityCtrl:getBuildCellList(params.bid)
	local iid
	if next(buildCellTbl) == nil then
		commonForwardFunc.forwardToBuild(params)
		return
	end
	for k, v in pairs(buildCellTbl) do
		if not buildLogic.buildLvIsFull(params.bid, v.info.iid) then
			iid = v.info.iid
			buildIndex = v.info.index
		end
	end
	if not iid then
		return
	end
	local cityBuildMgr = include("cityBuildMgr")
	local buildEntity = cityBuildMgr:getBuildByBid(tonumber(params.bid), iid)
	_ENV = cityBuildMgr
	cityBuildMgr.bid = params.bid
	cityBuildMgr.iid = iid
	cityBuildMgr.buildEntity = buildEntity
	local cityBuildMgr.index, buildInfo = buildIndex, cityBuildMgr
	SoraDRemoveAllPanelFromManager()
	_ENV = params.bid
	params.bid.upgradeData = buildInfo
	uiManager:show("BuildCreateInfo", params.bid)
	_ENV = uiManager
	uiManager.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
	uiManager.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
	uiManager.buildIndex = buildIndex
	SoraDSendMessage(uiManager)
	_ENV = uiManager
	uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
	SoraDSendMessage(uiManager)
end
function commonForwardFunc.forwardToBuild(params)
	local mainCityFunctions = include("mainCityFunctions")
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local buildIndex = params.buildIndex
	local maxLv, tmpIid
	if params.bid then
		maxLv, tmpIid = cityCtrl:getBuildMaxLv(params.bid)
		ret = 0 < tmpIid
		dump(cityCtrl:getBuildCellList(params.bid), "buildIndexDef--ret", 10)
		if not ret then
			buildIndex = mainCityFunctions.getMainCityCanBuildIndex(params.bid)
		else
			buildIndex = tonumber(cityCtrl:getBuildCell(params.bid, tmpIid).info.index)
		end
	else
	end
	local iid = params.iid or tmpIid
	local delay = params.delay or 0.3
	local isSelected = params.isSelected or true
	local needRecover = params.needRecover or false
	local isStep = params.isStep or false
	local isShowHand = params.isShowHand or true
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_GO_TO_BUILD"
	;(nil).buildID = params.bid
	;(nil).iid = iid
	;(nil).buildIndex = buildIndex
	;(nil).delay = delay
	;(nil).isSelected = isSelected
	;(nil).needRecover = needRecover
	;(nil).isStep = isStep
	;(nil).isShowHand = isShowHand
	SoraDSendMessage(nil)
	SoraDRemoveAllPanelFromManager()
end
function commonForwardFunc.forwardToTrainArmy(params)
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	_UPVALUE4_ = "cityCtrl"
	;("cityCtrl")[1] = BUILDID.CHARIOT_PLANT
	;("cityCtrl")[2] = BUILDID.STABLES
	;("cityCtrl")[3] = BUILDID.RANGE
	local ("cityCtrl")[4], bidList = BUILDID.BARRACKS, "cityCtrl"
	local bid
	for k, v in ipairs(bidList) do
		local buildCell = cityCtrl:getBuildCell(v, 0)
		local buildState
		if buildCell then
			buildState = tonumber(buildCell.info.state)
			if buildState == BUILD_STATE.NORMAL then
				bid = v
				break
			end
		end
	end
	bid = params and params.bid or bid
	if bid then
		ret = 0 < cityCtrl:getBuildMaxLv(params.bid)
		if not ret then
			print("建筑不存在")
			_ENV = "建筑不存在"
			;("建筑不存在").bid = bid
			commonForwardFunc.forwardToBuild("建筑不存在")
			return
		end
		_ENV = nil
		;(nil).bid = bid
		uiManager:show("soldiersCampView", nil)
	else
		_ENV = uiManager
		uiManager.bid = BUILDID.CHARIOT_PLANT
		commonForwardFunc.forwardToBuild(uiManager)
	end
end
return commonForwardFunc
