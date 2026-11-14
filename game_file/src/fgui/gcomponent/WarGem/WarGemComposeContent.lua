local warGemltCtrl = include("warGemltCtrl")
local wargemltCtrl = warGemltCtrl
local wargemResRead = include("wargemResRead")
local resDesRead = include("resDesRead")
local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local ESL = require_data("enchantment_stone_level", true)
local ESI = require_data("enchantment_stone_intensify", true)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local WarGemComposeContent = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarGem/WarGemComposeContent", WarGemComposeContent)
function WarGemComposeContent:onInit()
	_UPVALUE4_ = nil
	_UPVALUE4_, self.singleList, (nil)[1] = nil, nil, self.fields.Gem_1
	_UPVALUE4_, self.singleList, (nil)[2] = nil, nil, self.fields.Gem_2
	_UPVALUE4_, self.singleList, (nil)[3] = nil, nil, self.fields.Gem_3
	_UPVALUE4_, self.singleList, (nil)[4] = nil, nil, self.fields.Gem_4
	_UPVALUE4_, self.linkList, (nil)[1] = nil, nil, self.fields.Link_1
	_UPVALUE4_, self.linkList, (nil)[2] = nil, nil, self.fields.Link_2
	_UPVALUE4_, self.linkList, (nil)[3] = nil, nil, self.fields.Link_3
	_UPVALUE4_, self.linkList, (nil)[4] = nil, nil, self.fields.Link_4
	self.usmLinkList, (nil)[1] = nil, self.fields.Usm_link1
	self.usmLinkList, (nil)[2] = nil, self.fields.Usm_link2
	self.usmLinkList, (nil)[3] = nil, self.fields.Usm_link3
	self.usmLinkList, (nil)[4] = nil, self.fields.Usm_link4
	if not SoraDFIsRA() then
		self.singleList = table.reverse(self.singleList)
		self.linkList = table.reverse(self.linkList)
		self.usmLinkList = table.reverse(self.usmLinkList)
	end
	self.fields.Usm_daiji:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Usm_compose:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	self.fields.Usm_compose1:setBlendFunc(gl.ONE, gl.ONE)
	for i, v in ipairs(self.usmLinkList) do
		v:setBlendFunc(gl.ONE, gl.ONE)
	end
end
function WarGemComposeContent:setDaijiScale(scaleX, scaleY)
	self.fields.Usm_daiji:setScale(scaleX, scaleY)
end
function WarGemComposeContent:onShow()
end
function WarGemComposeContent:updateGem(gemID, midGemID, lv, idx)
	self.lv = lv
	self.idx = idx
	self.gemID = gemID
	self.toMid = midGemID
	print("gem====", gemID, midGemID)
	local color = wargemResRead.getQuality(midGemID)
	self.fields.Hole_mid:setColor(color)
	self.fields.Hole_mid:setGem(midGemID)
	self.fields.Text_attr:setString(wargemResRead.getAttrHtmlByID(midGemID))
	self.fields.Text_name:setString(wargemResRead.getName(midGemID))
	local curCount = self:getGemCount()
	local costCount = warGemltCtrl:getGemMaterialCount(midGemID, gemID)
	self.costCount = costCount
	local perCost = 1
	for i = 1, 4 do
		local link = self.linkList[i]
		if i <= costCount then
			local perCount = math.max(curCount - (i - 1) * perCost, 0)
			perCount = math.min(perCount, perCost)
			self.singleList[i]:initData(gemID, perCount, perCost)
			link:setSelected(true)
		else
			self.singleList[i]:initData(0)
			link:setSelected(false)
		end
	end
end
function WarGemComposeContent:getGemCount()
	local curCount = warGemCtrl:getItemCount(self.gemID)
	if self.lv and self.idx then
		local inlayGemID = warGemCtrl:getGemID(warGemCtrl:getEditPanelId(), self.lv, self.idx)
		if self.gemID == inlayGemID then
			curCount = curCount + 1
		end
	end
	return curCount
end
function WarGemComposeContent:showEffect()
	self.fields.Hole_mid:playMerge()
	self.fields.Usm_compose:play(false)
	self.fields.Usm_compose1:play(false)
	for i = 1, self.costCount do
		self.usmLinkList[i]:play(false)
	end
	SoraDPlaySound("warGem", 5)
end
return WarGemComposeContent
