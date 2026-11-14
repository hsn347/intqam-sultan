local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceBuildMainArmyPanel = class("AllianceBuildMainArmyPanel", baseFguiPanel)
function AllianceBuildMainArmyPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceBuildMainArmyPanel:ctor", self.viewName)
end
function AllianceBuildMainArmyPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "BuildWatchTower"
	end
	return self._packageList
end
function AllianceBuildMainArmyPanel:onInit()
	print("=======AllianceBuildMainArmyPanel:onInit")
	self.tableDataState, _ENV, self.tableSpare, _ENV, self.instanceData, _ENV, self.tableSingle, _ENV, self.tableRallyData, _ENV = print, print, print, print, print, print, print, print, print, print
	self.fields.Com_title:initData(i18n("common_text_3023"), handler(self, self.onClickClose))
	self.scroll = self.fields.List
	self.fields.List:setItemRenderer(handler(self, self.onItemRenerer))
	self.fields.List:setVirtual()
	self.labelCount = self.fields.Text_count
	self.labelNotice = self.fields.Text_notice
	self.labelNotice:setString(i18n("common_text_3025"))
end
function AllianceBuildMainArmyPanel:onShow()
	print("=======AllianceBuildMainArmyPanel:onShow")
end
function AllianceBuildMainArmyPanel:judgeBeQuit(target, data)
	if not allianceMgr:hasJoinAlliance() then
		self:removeFromParent()
	end
end
function AllianceBuildMainArmyPanel:judgeCloseView(target, data)
	if data.id == self.tableRallyData.id then
		self:removeFromParent()
	end
end
function AllianceBuildMainArmyPanel:serverMessage_RequestMapInstaceInfo(target, data)
	if not (data and data.data and next(data.data)) or not data.data.build then
		return
	end
	if data.data.build.id == self.tableRallyData.id then
		self.tableSingle, _ENV, self.tableRallyData = data.data.build, data.data.build, data.data.build
		self:initScrollData()
		self:updateScrollView()
	end
end
function AllianceBuildMainArmyPanel:OnMapMoveLineChange(target, data)
	local isChange = false
	if data.msg == "MESSAGE_SERVER_WORLD_MAP_MOVELINE_ADD" then
		for i, v in ipairs(data.data) do
			for _, value in ipairs(self.tableRallyData.guards) do
				if v.orgQueueId == value.queueId then
					isChange = true
					break
				end
			end
			if isChange then
				break
			end
		end
	elseif data.msg == "MESSAGE_SERVER_WORLD_MAP_MOVELINE_REMOVE" then
		for i, v in ipairs(data.data) do
			if v.to and v.to.id == self.instanceData.id then
				isChange = true
				break
			end
		end
	end
	if isChange and self.instanceData.x then
		kingdomMapCtrl:reqMapObjInfo(self.instanceData.x, self.instanceData.y, self.instanceData.id, self.instanceData.kingdomId)
	end
end
function AllianceBuildMainArmyPanel:initData(data, instanceData)
	dump(data, "AllianceBuildMainArmyPanel:initData")
	self.tableRallyData = data
	self.instanceData = instanceData
	self:initScrollData()
	self:updateScrollView()
	self.scroll:jumpToTop()
end
function AllianceBuildMainArmyPanel:initScrollData()
	for i, v in ipairs(self.tableRallyData.guards) do
		local isLaunched = false
		if self.tableDataState[v.queueId] then
			isLaunched = true
		end
		_ENV = nil
		;(nil).data = v
		;(nil).isLaunched = isLaunched
		table.insert(self.tableSingle, nil)
	end
	self.labelNotice:setVisible(#self.tableRallyData.guards <= 0)
	_ENV = nil
	;(nil).name = i18n("common_text_598")
	_ENV = self.tableSingle
	self.tableSingle.total = string.formatnumberthousands(self.tableRallyData.guardArmyCapacity)
	self.tableSingle.member = string.formatnumberthousands(self.tableRallyData.guardArmyTotalNum)
	;(nil).msg = i18n("common_text_155", self.tableSingle)
	self.labelCount:setString(i18n("common_text_1000", nil))
end
function AllianceBuildMainArmyPanel:onItemRenerer(index, obj)
	local v = self.tableSingle[index + 1]
	obj:setClickCallBack(handler(self, self.updateScrollSize))
	obj:initData(v.data)
	obj:setState(v.isLaunched)
end
function AllianceBuildMainArmyPanel:updateScrollSize(isLaunched, queueId)
	self.tableDataState[queueId] = isLaunched
	local index
	for i, v in ipairs(self.tableSingle) do
		if queueId == v.data.queueId then
			v.isLaunched = isLaunched
			index = i
			break
		end
	end
	self.fields.List:setNumItems(#self.tableSingle)
	if isLaunched then
		self.fields.List:scrollToView(index - 1)
	end
end
function AllianceBuildMainArmyPanel:updateScrollView()
	self.fields.List:setNumItems(#self.tableSingle)
end
return AllianceBuildMainArmyPanel
