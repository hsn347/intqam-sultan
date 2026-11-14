local gametop = gModuleMgr.getObject("gametop")
local publicRead = include("publicRead")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local newHeroGainChipMethodViewPanel = class("newHeroGainChipMethodViewPanel", baseFguiPanel)
function newHeroGainChipMethodViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("newHeroGainChipMethodViewPanel:ctor", self.viewName)
end
function newHeroGainChipMethodViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NewHeroView"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function newHeroGainChipMethodViewPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======newHeroGainChipMethodViewPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("hero_title_11"))
	self.fields.Button_qustion:addClickListener(handler(self, self.btnQuestionClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData(self.param.itemID, self.param.needCount, self.param.noExchange)
	self.fields.HeroChip:fixPos()
	self.fields.Button_qustion:fixPos()
	self.fields.Text_chipName:fixPos()
	self.fields.Text_have:fixPos()
end
function newHeroGainChipMethodViewPanel:onShow()
	print("=======newHeroGainChipMethodViewPanel:onShow")
end
function newHeroGainChipMethodViewPanel:endShow()
	if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		self:removeFromParent()
	end
end
function newHeroGainChipMethodViewPanel:onHide()
	print("=======newHeroGainChipMethodViewPanel:onHide")
end
function newHeroGainChipMethodViewPanel:onDispose()
	print("=======newHeroGainChipMethodViewPanel:onDispose")
end
function newHeroGainChipMethodViewPanel:btnQuestionClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemID
	;(nil).needCount = self.needCount
	;(nil).heroID = self.heroID
	uiManager:show("newHeroGainChipView", nil)
end
function newHeroGainChipMethodViewPanel:onItemRenderer(index, obj)
	obj:initData(self.infoList[index + 1])
end
function newHeroGainChipMethodViewPanel:initData(itemID, needCount, noExchange)
	self.itemID = itemID
	self.needCount = needCount
	local isDress = self.param.isDress
	self.infoList, _ENV = nil, nil
	if isDress then
		self:initMaterial()
		for k, v in ipairs(self.param.output) do
			if v.jumpType == 2 then
				for m, n in ipairs(v.type) do
					if not activityShowCtrl:getParamByID(n) then
						local _ENV, param = activityShowCtrl:getParamByID(n), activityShowCtrl:getParamByID(n)
					end
					local _classtype = param.classtype or 0
					local cfgClassType = serviceFunctions.split(v.classtype[m], ",")
					if #v.classtype == 0 or tonumber(v.classtype[m]) == 0 then
						_ENV = nil
						;(nil).methodType = gHeroChipMethodType.dress
						;(nil).output = v
						;(nil).activityID = n
						table.insert(self.infoList, nil)
					elseif 0 < #cfgClassType then
						for i, classType in ipairs(cfgClassType) do
							_ENV = nil
							;(nil).methodType = gHeroChipMethodType.dress
							;(nil).output = v
							;(nil).activityID = n
							;(nil).classType = tonumber(classType)
							table.insert(self.infoList, nil)
						end
					end
				end
			else
				_ENV = ipairs(v.type)
				ipairs(v.type).methodType = gHeroChipMethodType.dress
				ipairs(v.type).output = v
				table.insert(self.infoList, ipairs(v.type))
			end
		end
		self.fields.Text_chipName:setString(publicRead.getName(self.itemID))
		self.fields.HeroChip:initData(self.itemID, self.needCount, self.heroID, isDress)
		local itemNum = backpackCtrl:getItemCount(self.itemID)
		self.fields.Button_qustion:setVisible(false)
		_ENV = isDress
		_ENV = publicRead.getName(self.itemID)
		publicRead.getName(self.itemID).total = self.needCount
		publicRead.getName(self.itemID).member = itemNum
		isDress.num = i18n("common_text_155", publicRead.getName(self.itemID))
		self.fields.Text_have:setString(i18n("common_text_531", isDress))
		self.fields.Text_have:setColor(cc.c3b(190, 40, 40))
		self.fields.List:setNumItems(#self.infoList)
		return
	end
	self.chipInfo = heroltCtrl.getChipInfo(self.itemID)
	if self.chipInfo == nil then
		self:close()
		return
	end
	self.heroID = self.chipInfo.heroID
	if noExchange then
		local _ENV, typeArray = self.chipInfo.heroID, self.chipInfo.heroID
		for k, v in ipairs(self.chipInfo.type) do
			if v ~= gHeroChipMethodType.exchange then
				table.insert(typeArray, v)
			end
		end
		self.chipInfo.type = typeArray
	end
	for m, n in ipairs(self.chipInfo.type) do
		if n == gHeroChipMethodType.epicWar then
			for i, v in ipairs(self.chipInfo.output) do
				_ENV = cc.c3b(190, 40, 40)
				cc.c3b(190, 40, 40).methodType = n
				cc.c3b(190, 40, 40).bringData = v
				cc.c3b(190, 40, 40).heroID = self.heroID
				table.insert(self.infoList, cc.c3b(190, 40, 40))
			end
		elseif n == gHeroChipMethodType.activity and self.chipInfo.output[m] then
			_ENV = ipairs(self.chipInfo.output)
			ipairs(self.chipInfo.output).methodType = n
			ipairs(self.chipInfo.output).bringData = self.chipInfo
			ipairs(self.chipInfo.output).heroID = self.heroID
			ipairs(self.chipInfo.output).activityID = self.chipInfo.output[m]
			table.insert(self.infoList, ipairs(self.chipInfo.output))
		else
			_ENV = ipairs(self.chipInfo.output)
			ipairs(self.chipInfo.output).methodType = n
			ipairs(self.chipInfo.output).bringData = self.chipInfo
			ipairs(self.chipInfo.output).heroID = self.heroID
			table.insert(self.infoList, ipairs(self.chipInfo.output))
		end
	end
	self:initView()
end
function newHeroGainChipMethodViewPanel:initMaterial()
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local material = backpackltCtrl:getMaterialOfMergeItem(self.itemID)
	self.controllers.c1:setSelectedIndex(material == nil and 0 or 1)
	if material == nil then
		return
	end
	local materialId = material[1].id
	local count = material[1].count
	local itemCount = backpackCtrl:getItemCount(materialId)
	self.fields.icon_item:setURL(publicRead.getIcon(materialId))
	self.fields.Text_item_desc:setString(publicRead.getName(materialId))
	self.fields.Text_item_num:setString(itemCount .. "/" .. count)
	self.fields.Text_item_num:setColor(count <= itemCount and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
end
function newHeroGainChipMethodViewPanel:initView()
	self.fields.Text_chipName:setString(publicRead.getName(self.itemID))
	self.fields.HeroChip:initData(self.itemID, self.needCount, self.heroID)
	local itemNum = backpackCtrl:getItemCount(self.itemID)
	publicRead = publicRead.getName(self.itemID)
	publicRead = publicRead.getName(self.itemID)
	publicRead.getName(self.itemID).total = self.needCount
	publicRead.getName(self.itemID).member = itemNum
	publicRead.getName(self.itemID).num = i18n("common_text_155", publicRead.getName(self.itemID))
	self.fields.Text_have:setString(i18n("common_text_531", publicRead.getName(self.itemID)))
	if type(self.needCount) == "string" and self.needCount == "MAX" then
		self.fields.Text_have:setColor(cc.c3b(255, 255, 255))
	elseif type(self.needCount) == "number" then
		if itemNum >= self.needCount then
			self.fields.Text_have:setColor(cc.c3b(0, 255, 0))
		else
			self.fields.Text_have:setColor(cc.c3b(255, 0, 0))
		end
	end
	self.fields.List:setNumItems(#self.infoList)
end
return newHeroGainChipMethodViewPanel
