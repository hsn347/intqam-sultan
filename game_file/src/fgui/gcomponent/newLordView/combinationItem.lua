local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local godArmsCtrl = SoraDGetCtrl("godArmsCtrl")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local baseComponent = require("fgui.base.baseComponent")
local combinationItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/combinationItem", combinationItem)
function combinationItem:onInit()
	self.fields.Text_inUse:setString(i18n("privilege_text_130"))
	self.fields.Button_use:setString(i18n("common_text_314"))
	self.fields.Button_use:addClickListener(handler(self, self.onUseClick))
	self.list, _ENV = self.fields.Button_use.addClickListener, self.fields.Button_use.addClickListener
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.List:setAlignCenter(true)
	self.fields.Button_rename:addClickListener(handler(self, self.onClickRename))
	self.fields.Button_rename:fixPos()
end
function combinationItem:onShow()
end
function combinationItem:onListRenderer(index, obj)
	obj:initData(self.list[index + 1], self.index, self.isFromUsing)
end
function combinationItem:initData(index, isFromUsing)
	self.index = index
	self.list, combinationCtrl, self.isFromUsing = nil, nil, isFromUsing
	local ctype = combinationCtrl.COMBINATION_TYPE.COMBINATION
	local name = combinationCtrl:getSetName(ctype, self.index)
	self.fields.Label_title:setString(name)
	if self.isFromUsing then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(self.index == combinationCtrl:getCurSetId() and 1 or 0)
	end
	local slotList = combinationCtrl:getBaseCombinationSlotList()
	for _, slotInfo in ipairs(slotList) do
		if slotInfo.ctype ~= combinationCtrl.COMBINATION_TYPE.WARGEM or SoraDGetCtrl("cityCtrl"):getBuildCell(BUILDID.MIRACLE, 0) then
			combinationCtrl = BUILDID.MIRACLE
			BUILDID.MIRACLE.index = slotInfo.ctype
			BUILDID.MIRACLE.ctype = slotInfo.ctype
			BUILDID.MIRACLE.fieldKey = slotInfo.fieldKey
			BUILDID.MIRACLE.iconFrame = slotInfo.iconFrame
			table.insert(self.list, BUILDID.MIRACLE)
		end
	end
	local num = #self.list
	local tableArmsSkill = godArmsCtrl:getSkillList()
	local armIndex = 1
	for k, v in ipairs(tableArmsSkill) do
		local info = godArmsCtrl:getArmsInfo(v.weaponID)
		if godArmsRuneCtrl:isArmShowRune(v) and not info.isLock then
			combinationCtrl = v
			v.index = num + armIndex
			v.arm = v
			table.insert(self.list, v)
			armIndex = armIndex + 1
		end
	end
	num = num + armIndex - 1
	local divineIDList = divineBeastCtrl:getUnlockBeastIDList()
	local markIndex = 1
	for i, v in ipairs(divineIDList) do
		if divineBeastMarkCtrl:getIsFuncOpen(v) then
			combinationCtrl = v
			v.index = num + markIndex
			v.ctype = combinationCtrl.COMBINATION_TYPE.DIVINEBEASTMARK
			v.divineID = v
			table.insert(self.list, v)
			markIndex = markIndex + 1
		end
	end
	num = num + markIndex - 1
	self.fields.List:setNumItems(#self.list)
	local line = math.ceil(#self.list / 5)
	self.fields.List:setHeight(line * 104)
	local combData = combinationCtrl:getCombinationData(self.index)
	if combinationCtrl:hasConfiguredSet(combData) then
		self.fields.Button_use:setEnabled(true)
	else
		self.fields.Button_use:setEnabled(false)
	end
end
function combinationItem:onUseClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).setID = self.index
	;(nil).isFromUsing = self.isFromUsing
	uiManager:show("combinationCostView", nil)
end
function combinationItem:onClickRename()
	SoraDPlaySound()
	_ENV = nil
	;(nil).setID = self.index
	;(nil).renameType = 4
	uiManager:show("lordEquipRename", nil)
end
return combinationItem
