local commonTestView = class("commonTestView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonTestView")
	end
	return target
end)
function commonTestView:ctor()
	self.typeArray, _ENV, self.isHideCurrentSceneView = nil, nil, true
	self.ccs_node = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.scroll = SoraDGetChildByName(self, "Top_Size_Scroll")
end
function commonTestView:initItemData()
	self.ccs_node:setTitle("道具预览")
	local _ENV, showArray = self.ccs_node.setTitle, self.ccs_node.setTitle
	local itemArray = require("app." .. LocalTblPath .. ".config_client.itemdescribe")
	for k, v in pairs(itemArray) do
		if v and type(v) == "table" then
			_ENV = nil
			;(nil).index = v.index or 0
			;(nil).icon = v.icon or "icon_item_common.png"
			;(nil).name = v.name or "不知道什么鬼"
			table.insert(showArray, nil)
		end
	end
	table.sort(showArray, function(a, b)
		return a.index < b.index
	end)
	local height = math.max(self.scroll:getContentSize().height, math.ceil(#showArray / 5) * 160)
	self.scroll:setInnerContainerSize(cc.size(640, height))
	for k, v in ipairs(showArray) do
		local node = display.newNode()
		local itemSp = display.newSprite("#" .. v.icon)
		itemSp:addTo(node)
		local textIndex = ccui.Text:create("", "", 24)
		textIndex:setString(v.index .. "\n" .. i18n(v.name))
		textIndex:setPosition(cc.p(0, -60))
		textIndex:addTo(node)
		local _h = k % 5 == 0 and 5 or k % 5
		local _l = math.ceil(k / 5)
		node:setPosition(_h * 120 - 40, height - _l * 160 + 80)
		node:addTo(self.scroll)
	end
end
function commonTestView:initRechargeTypeData()
	self.ccs_node:setTitle("充值节点样式展示")
	local effectEventGift = include("effectEventGift")
	for k, v in pairs(effectEventGift.gCiteImgType) do
		_ENV = nil
		;(nil).cType = k
		;(nil).data = v
		table.insert(self.typeArray, nil)
	end
	table.sort(self.typeArray, function(a, b)
		return a.cType < b.cType
	end)
	local height = math.max(self.scroll:getContentSize().height, math.ceil(#self.typeArray / 5) * 160)
	self.scroll:setInnerContainerSize(cc.size(640, height))
	for k, v in ipairs(self.typeArray) do
		local node = effectEventGift.getGiftNode(v.cType)
		local textIndex = ccui.Text:create("", "", 24)
		textIndex:setString(v.cType)
		textIndex:setPosition(cc.p(0, 0))
		textIndex:addTo(node)
		local _h = k % 5 == 0 and 5 or k % 5
		local _l = math.ceil(k / 5)
		node:setPosition(_h * 120 - 40, height - _l * 160 + 80)
		node:addTo(self.scroll)
	end
end
return commonTestView
