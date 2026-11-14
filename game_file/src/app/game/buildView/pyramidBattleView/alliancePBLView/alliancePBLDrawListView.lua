local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceDesRead = include("allianceDesRead")
local alliancePBLDrawListView = class("alliancePBLDrawListView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("alliancePBLDrawListView")
	end
	return target
end)
function alliancePBLDrawListView:ctor()
	self.drawData, pyramidWarCtrl = nil, nil
	self.curAid = 1
	self.curGid = 1
	self.ownGid = pyramidWarCtrl:getOwnPBLLegion()
	if self.ownGid then
		self.ownGid = self.ownGid.legionId
	end
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.nodeBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeTab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_tab")
	self.scroll = SoraDGetChildByName(self, "ScrollView_scroll")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self.labelInfo = SoraDGetChildByName(self, "Text_info")
	self.labelPower = SoraDGetChildByName(self, "Text_power")
	self.labelPower:setString(i18n("pyramid_text_110"))
	self.labelInfo:setString(i18n("pyramid_text_111"))
	self.spriteOwnFlag = SoraDGetChildByName(self, "Sprite_ownflag")
	self.spriteOwnFlag:setVisible(false)
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelDes:setVisible(false)
	self.labelDes:setString(i18n("common_text_927"))
	self.nodeClone = SoraDGetChildByName(self, "Node_clone")
	self.btnLfet = SoraDGetChildByName(self, "Button_Left")
	self.btnRight = SoraDGetChildByName(self, "Button_Right")
	self.btnLfet:addTouchEventListener(handler(self, self.btnBackClick))
	self.btnRight:addTouchEventListener(handler(self, self.btnBackClick))
end
function alliancePBLDrawListView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_PBL_GET_DRAW_BACK", handler(self, self.updateData))
end
function alliancePBLDrawListView:initView()
	self.nodeTab:setContentSize(cc.size(546, 56))
	self.nodeTab:setNewStyle(true)
	_ENV, _ENV = self.nodeTab, self.nodeTab.setNewStyle
	self.nodeTab.title = i18n("pyramid_btn_09")
	_ENV, self.nodeTab.setNewStyle[1], self.nodeTab.handle = self.nodeTab, self.nodeTab, handler(self, self.OnBtnChangeClick)
	self.nodeTab.title = i18n("pyramid_btn_10")
	_ENV, self.nodeTab.setNewStyle[2], self.nodeTab.handle = self.nodeTab, self.nodeTab, handler(self, self.OnBtnChangeClick)
	self.nodeTab.title = i18n("pyramid_btn_11")
	self.nodeTab.setNewStyle[3], self.nodeTab.handle = self.nodeTab, handler(self, self.OnBtnChangeClick)
	local arry = self.nodeTab.setNewStyle
	_ENV = self
	self.tabNum = 3
	self.defaultClick = 1
	self.tabsetArray = arry
	self.nodeTab:initView(self)
end
function alliancePBLDrawListView:OnBtnChangeClick(tag)
	self.curTab = tag
	self.curGid = self.curTab
	_ENV = nil
	;(nil).num = self.curAid
	self.nodeBg:setTitleName(i18n("pyramid_text_76", nil))
	if self.drawData[self.curAid] and self.drawData[self.curAid][self.curGid] then
		self:updateFlag()
		self:updateScroll()
		self:updateView()
	else
		self.spriteOwnFlag:setVisible(false)
		self:updateView()
	end
end
function alliancePBLDrawListView:updateFlag()
	if self.drawData[self.curAid] then
		self.spriteOwnFlag:setVisible(false)
		for i, v in ipairs(self.drawData[self.curAid]) do
			for x, data in ipairs(v) do
				if data.legionId == self.ownGid then
					self.spriteOwnFlag:setVisible(true)
					self.spriteOwnFlag:setPosition(SoraDFSign(570 - (i - 1) * 175), 310)
					return
				end
			end
		end
	end
end
function alliancePBLDrawListView:initData(index)
	self.curAid = index
	self:initView()
end
function alliancePBLDrawListView:updateView()
	pyramidWarCtrl:newAreaGroupDataReq(self.curAid)
	SoraDShowLoading(self)
end
function alliancePBLDrawListView:updateData(target, data)
	local data = data.data
	if data.aid and data.data then
		if self.drawData[data.aid] == nil then
			self.drawData[data.aid], _ENV = nil, nil
		end
		local _ENV, ret = self.drawData, self.drawData
		for k, v in pairs(data.data) do
			ret[tonumber(k)] = v
			table.sort(ret[tonumber(k)], function(l, r)
				return l.power > r.power
			end)
		end
		self.drawData[data.aid] = ret
		self:updateFlag()
		self:updateScroll()
	end
	SoraDCloseLoading(self)
end
function alliancePBLDrawListView:updateScroll()
	if self.drawData[self.curAid] and self.drawData[self.curAid][self.curGid] then
		local data = self.drawData[self.curAid][self.curGid]
		self.labelDes:setVisible(#data <= 0)
		self.scroll:updateScrollView(cc.size(550, 58), data, 1)
	end
end
function alliancePBLDrawListView:createSingle()
	local single = self.nodeClone:clone()
	single.power = SoraDGetChildByName(single, "Text_power")
	single.name = SoraDGetChildByName(single, "Text_name")
	single.index = SoraDGetChildByName(single, "Text_index")
	single.flag = SoraDGetChildByName(single, "Node_flag")
	single.nodeOwn = SoraDGetChildByName(single, "Node_own")
	return single
end
function alliancePBLDrawListView:refreshSingle(single, data, otherData)
	_ENV = nil
	;(nil).abbr = data.abbr
	;(nil).name = data.legionName
	local nameStr = string.format("%s#%d", i18n("common_text_186", nil), data.kid)
	single.power:setString(string.formatnumberthousands(data.power))
	single.name:setString(nameStr)
	single.index:setString(string.formatnumberthousands(single:getTag()))
	single.nodeOwn:setVisible(data.legionId == self.ownGid)
	single.flag:removeAllChildren()
	allianceDesRead.getFlagWithParticle(data.flag, single.flag)
end
function alliancePBLDrawListView:btnBackClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if target == self.btnLfet then
			self.curAid = self.curAid - 1
		else
			self.curAid = self.curAid + 1
		end
		if self.curAid <= 0 then
			self.curAid = 8
		elseif self.curAid > 8 then
			self.curAid = 1
		end
		self.nodeTab:clickByTag(1)
	end
end
return alliancePBLDrawListView
