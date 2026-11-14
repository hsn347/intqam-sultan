local gametop = gModuleMgr.getObject("gametop")
local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local colorGreen = cc.c3b(60, 120, 80)
local colorRed = cc.c3b(149, 72, 72)
local colorBlue = cc.c3b(34, 107, 131)
local colorYellow = cc.c3b(255, 255, 0)
_ENV = 255
_ENV = 0
;(0).formatText = "common_text_3623"
;(255)[gMobilizationOperateType.OPERATE_COMMIT], (0).textColor = 0, colorGreen
_ENV = 0
;(0).formatText = "common_text_3622"
;(255)[gMobilizationOperateType.OPERATE_ACCEPT], (0).textColor = 0, colorBlue
_ENV = 0
;(0).formatText = "common_text_3624"
;(255)[gMobilizationOperateType.OPERATE_ABORT], (0).textColor = 0, colorRed
_ENV = 0
;(0).formatText = "common_text_3637"
;(255)[gMobilizationOperateType.OPERATE_DELETE], (0).textColor = 0, colorYellow
_ENV = 0
;(0).formatText = "common_text_3674"
;(255)[gMobilizationOperateType.OPERATE_BUYTIMES], (0).textColor = 0, colorBlue
local styleTb = 255
local allianceTaskLogView = class("allianceTaskLogView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceTaskLogView")
	end
	return target
end)
function allianceTaskLogView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.scroll = SoraDGetChildByName(self, "ScrollView_log")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_3565"))
	self.itemData, _ENV, self.tableSpare, _ENV, self.nodeSingle = SoraDGetChildByName(self, "Node_single"), SoraDGetChildByName(self, "Node_single"), SoraDGetChildByName(self, "Node_single"), SoraDGetChildByName(self, "Node_single"), SoraDGetChildByName(self, "Node_single")
	self:initView()
end
function allianceTaskLogView:initView()
	self.data = playerMobilizationCtrl:getOperateLog()
	dump(self.data, "allianceTaskLogView==data", 10)
	if self.data == nil or #self.data == 0 then
		_ENV, _ENV = self.data, #self.data
		self.data[1] = 0
		self.data, (#self.data)[1] = #self.data, self.data
	end
	for i, v in ipairs(self.data) do
		playerMobilizationCtrl = nil
		;(nil).data = v
		;(nil).itemNode = nil
		table.insert(self.itemData, nil)
	end
	dump(self.itemData, "operateLog", 10)
	self:updateScrollView()
end
function allianceTaskLogView:updateScrollView()
	self:updateScrollSize()
	self:updateScrollCell()
end
function allianceTaskLogView:updateScrollSize()
	dump(self.data, "self.dataself.data", 10)
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollContentSize = self.scroll:getContentSize()
	local accumulateHeight = 0
	local accumulateHeight = #self.data * 58
	for i, v in ipairs(self.itemData) do
		v.itemPosY = accumulateHeight - i * 58
		v.itemPosX = 10
		if v.itemNode then
			print("现在的节点", i)
			v.itemNode:setPositionY(v.itemPosY)
			v.itemNode:setPositionX(v.itemPosX)
		end
	end
	local totalCellHeight = accumulateHeight
	if totalCellHeight < scrollContentSize.height then
		local deltaY = scrollContentSize.height - totalCellHeight
		totalCellHeight = scrollContentSize.height
		for i, v in ipairs(self.itemData) do
			v.itemPosY = v.itemPosY + deltaY
			if v.itemNode then
				v.itemNode:setPositionY(v.itemPosY)
			end
		end
	end
	local scrollInnerNewH = totalCellHeight
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(scrollWidth, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
function allianceTaskLogView:updateScrollCell()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.scroll
	for i, v in ipairs(self.itemData) do
		if v.itemNode then
			if v.itemPosY + 80 < tableShowH.beginY or v.itemPosY > tableShowH.endY then
				v.itemNode:setVisible(false)
				table.insert(self.tableSpare, v.itemNode)
				v.itemNode = nil
			end
		else
			if tableShowH.beginY <= v.itemPosY and tableShowH.endY >= v.itemPosY then
				if 0 < #self.tableSpare then
					v.itemNode = table.remove(self.tableSpare)
					v.itemNode:setVisible(true)
				else
					v.itemNode = self.nodeSingle:clone()
					v.itemNode:addTo(self.scroll)
				end
				v.itemNode:setPosition(v.itemPosX, v.itemPosY)
				self:initSingleView(v.data, v.itemNode)
			else
			end
		end
	end
end
function allianceTaskLogView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollCell()
	end
end
function allianceTaskLogView:initSingleView(data, single)
	local tasktypeid = data.tasktypeid or 0
	local formatText = styleTb[data.operateType] and styleTb[data.operateType].formatText or ""
	local taskName = ""
	local taskInfo
	if formatText ~= "" and formatText and tasktypeid and data.operateType ~= gMobilizationOperateType.OPERATE_BUYTIMES then
		if mobilizationltCtrl:getTaskName(tasktypeid) then
			taskName = i18n(mobilizationltCtrl:getTaskName(tasktypeid))
		end
		taskInfo = mobilizationltCtrl:getTaskInfo(tasktypeid)
	end
	if not taskInfo then
		taskInfo, styleTb = mobilizationltCtrl:getTaskInfo(tasktypeid), mobilizationltCtrl:getTaskInfo(tasktypeid)
	end
	local strContent
	if formatText == "" then
		strContent = i18n("common_text_3629")
	else
		styleTb = mobilizationltCtrl:getTaskName(tasktypeid)
		mobilizationltCtrl:getTaskName(tasktypeid).name = data.name
		mobilizationltCtrl:getTaskName(tasktypeid).task = taskName
		mobilizationltCtrl:getTaskName(tasktypeid).score = taskInfo.point
		mobilizationltCtrl:getTaskName(tasktypeid).time = 1
		strContent = i18n(formatText, mobilizationltCtrl:getTaskName(tasktypeid))
	end
	local text_content = SoraDGetChildByName(single, "txt_content")
	local text_time = SoraDGetChildByName(single, "txt_time")
	text_content:setString(strContent)
	text_content:setColor(data.operateType and styleTb[data.operateType].textColor or cc.c3b(120, 120, 120))
	if formatText ~= "" then
		local timeStr = os.date("%m-%d %H:%M", data.time)
		text_time:setString(timeStr)
	end
end
return allianceTaskLogView
