local intetiorCtrl = SoraDGetCtrl("intetiorCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local mailFunctions = include("mailFunctions")
local intetiorDef = include("intetiorDef")
local intetiorRead = include("intetiorRead")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local IntetiorAllocationPanel = class("IntetiorAllocationPanel", baseFguiPanel)
function IntetiorAllocationPanel:ctor(...)
	self.super.ctor(self, ...)
	print("IntetiorAllocationPanel:ctor", self.viewName)
end
function IntetiorAllocationPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function IntetiorAllocationPanel:onInit()
	print("=======IntetiorAllocationPanel:onInit")
	self.uidList, _ENV, self.chooseResNum, _ENV, self.allocationData, _ENV = print, print, print, print, print, print
	self.fields.Panel_bg:setString(i18n("parliament_btn_08"))
	self.fields.Button_allocation:addClickListener(handler(self, self.onClickAllocation))
	self.fields.Button_allocation:setString(i18n("common_text_1441"))
	self.fields.Text_Tip:setString(i18n("parliament_text_151"))
	_ENV = i18n("parliament_text_151")
	i18n("parliament_text_151").num = 1
	self.fields.Text_Bottom:setString(i18n("parliament_text_153", i18n("parliament_text_151")))
	self.fields.text_title:setString(i18n("parliament_btn_07"))
	self.allocalMax = intetiorRead:getAllocationMax()
	self.tableResType = intetiorDef.RES_KEY
	self.fields.List_OwnRes:setItemRenderer(handler(self, self.onItemRender))
	self.fields.List_Head:setItemRenderer(handler(self, self.onItemHeadRender))
	self.fields.List_ResChoose:setItemRenderer(handler(self, self.onItemResChooseRender))
	self.fields.List_AlloRes:setItemRenderer(handler(self, self.onItemResRender))
end
function IntetiorAllocationPanel:onShow()
	print("=======IntetiorAllocationPanel:onShow")
	self:updateResourceInfo()
	self:initScrollView()
	self.fields.List_Head:setNumItems(5)
	self:updateChooseResInfo()
	self:updateBtn()
end
function IntetiorAllocationPanel:onItemRender(index, target)
	target:setIcon(publicRead.getSmallIcon(self.tableResType[index + 1]))
	target:setTitleText(SoraDConvertNumberWithUnit(self.tableRescources[tostring(self.tableResType[index + 1])]))
end
function IntetiorAllocationPanel:onItemHeadRender(index, target)
	target:initData(self.uidList[index + 1])
	target:setHandle(handler(self, self.onClickHead), handler(self, self.onClickRemove), index + 1)
end
function IntetiorAllocationPanel:onItemResChooseRender(index, target)
	target:initData(self.showList[index + 1])
	target:setSliderCallBack(handler(self, self.singleSliderChange))
end
function IntetiorAllocationPanel:singleSliderChange()
	self.chooseResNum, _ENV = nil, nil
	for i, v in ipairs(self.tableResType) do
		local target = self.fields.List_ResChoose:getChildAt(i - 1)
		local resid, num = target:getChooseNum()
		if 0 < num then
			self.chooseResNum[tostring(resid)] = num
		else
			self.chooseResNum[tostring(resid)] = nil
		end
	end
	self:updateChooseResInfo()
	self:updateBtn()
end
function IntetiorAllocationPanel:onItemResRender(index, target)
	target:setIcon(publicRead.getSmallIcon(self.tableResType[index + 1]))
	target:setString(SoraDConvertNumberWithUnit((self.chooseResNum[self.tableResType[index + 1]] or 0) * math.max(1, table.nums(self.uidList))))
end
function IntetiorAllocationPanel:updateResourceInfo()
	self.tableRescources = intetiorCtrl:getKingdomResource()
	dump(self.tableRescources, "tableRescources")
	self.fields.List_OwnRes:setNumItems(table.nums(self.tableResType))
end
function IntetiorAllocationPanel:updateChooseResInfo()
	_ENV = nil
	;(nil).num = table.nums(self.uidList)
	self.fields.Text_Bottom:setString(i18n("parliament_text_153", nil))
	self.fields.List_AlloRes:setNumItems(table.nums(self.tableResType))
end
function IntetiorAllocationPanel:updateBtn()
	local bEnable = false
	if table.nums(self.uidList) > 0 then
		for i, v in pairs(self.chooseResNum) do
			if 0 < v then
				bEnable = true
			end
		end
	end
	self.fields.Button_allocation:setEnabled(bEnable)
end
function IntetiorAllocationPanel:initScrollView()
	local resDataAllocation = self.proxy:getResDataAllocation()
	self.showList, intetiorCtrl = self.proxy, self.proxy
	local resData = intetiorCtrl:getKingdomResource()
	for _, v in ipairs(self.tableResType) do
		local resCurrer = resData[v] or 0
		local resAllocation = resDataAllocation[v] or 0
		local resMax = self.allocalMax[v] or 0
		local max = math.max(0, resMax - resAllocation)
		print("table.nums(self.uidList)", table.nums(self.uidList))
		local canMax = math.max(0, math.min(math.floor(resCurrer / math.max(1, table.nums(self.uidList))), resMax - resAllocation))
		intetiorCtrl = math.min(math.floor(resCurrer / math.max(1, table.nums(self.uidList))), resMax - resAllocation)
		math.min(math.floor(resCurrer / math.max(1, table.nums(self.uidList))), resMax - resAllocation).resid = v
		math.min(math.floor(resCurrer / math.max(1, table.nums(self.uidList))), resMax - resAllocation).max = max
		math.min(math.floor(resCurrer / math.max(1, table.nums(self.uidList))), resMax - resAllocation).canMax = canMax
		math.min(math.floor(resCurrer / math.max(1, table.nums(self.uidList))), resMax - resAllocation).count = resCurrer
		table.insert(self.showList, math.min(math.floor(resCurrer / math.max(1, table.nums(self.uidList))), resMax - resAllocation))
	end
	self.fields.List_ResChoose:setNumItems(table.nums(self.showList))
end
function IntetiorAllocationPanel:onClickAllocation()
	SoraDPlaySound()
	_ENV = nil
	;(nil).name = self:getUidsName()
	local showMsg = i18n("parliament_text_86", nil)
	SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			intetiorCtrl:reqParliamentTreasuryAwardEx(self:getAwardMap())
			SoraDShowLoading(self)
		end
	end)
end
function IntetiorAllocationPanel:getUidsName()
	local str = ""
	for i = 1, 5 do
		local target = self.fields.List_Head:getChildAt(i - 1)
		local _str = target:getName()
		if _str then
			if str ~= "" then
				str = str .. ","
			end
			str = str .. _str
		end
	end
	return str
end
function IntetiorAllocationPanel:getAwardMap()
	local _ENV, ret
	for _, v in ipairs(self.uidList) do
		ret[tostring(v.uid)] = self.chooseResNum
	end
	return ret
end
function IntetiorAllocationPanel:onClickHead(index)
	local layer = uiManager:show("LordSelectView").view
	layer:initData(lordSearchType.PIGEON, 1, i18n("parliament_btn_08"))
	layer:setTitleText(i18n("parliament_btn_08"))
	layer:setIsSortPower(true)
	layer:setShieldMap(self:getShieldMapUID())
	layer:setHandle(function(tableUID, num, target, tableData)
		local _ENV, userData
		local data = tableData[1]
		if data then
			local abbr
			if data.getProperty then
				local allianceMgr = SoraDGetCtrl("allianceMgr")
				abbr = allianceMgr:getAllianceProperty("abbr")
			else
				abbr = data.allianceAbbr
			end
			userData.abbr = abbr
			userData.name = data.getProperty and data:getProperty("nickName") or data.nickName
			userData.iconID = data.getProperty and data:getProperty("iconID") or data.iconID
			userData.avatar = data.getProperty and data:getProperty("avatar") or data.avatar
			userData.uid = tableUID[1]
			table.insert(self.uidList, userData)
			self.fields.List_Head:setNumItems(5)
			SoraDShowLoading(self)
			intetiorCtrl:reqParliamentTreasuryPlayerDayAward(tableUID[1])
		end
	end)
end
function IntetiorAllocationPanel:getShieldMapUID()
	lordInfoCtrl = nil
	local (nil)[lordInfoCtrl:getLordInfo().base.uid], ret = true, nil
	for i, v in ipairs(self.uidList) do
		ret[v.uid] = true
	end
	return ret
end
function IntetiorAllocationPanel:onClickRemove(index)
	self.proxy:deletResDataAllocation(index)
	table.remove(self.uidList, index)
	self:initScrollView()
	self.fields.List_Head:setNumItems(5)
end
function IntetiorAllocationPanel:getIndexByUid(uid)
	for i, v in ipairs(self.uidList) do
		if v.uid == uid then
			return i
		end
	end
end
return IntetiorAllocationPanel
