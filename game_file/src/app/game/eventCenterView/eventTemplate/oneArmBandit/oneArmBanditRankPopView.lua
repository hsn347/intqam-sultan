local GridScrollView = include("GridScrollView")
local gametop = gModuleMgr.getObject("gametop")
local oneArmBanditCtrl = gametop.playertop_:getModule("oneArmBanditCtrl")
local oneArmBanditRankPopView = class("oneArmBanditRankPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("oneArmBanditRankPopView")
	end
	return target
end)
function oneArmBanditRankPopView:ctor()
	self.isAddToPopManager = true
	self:bandWidget()
	self:initData()
	SoraDAddMessage(self, "MESSAGE_ONEARMBANDIT_NOTIFY_BACK", function(target, data)
		if data.rankListChange then
			self:initData()
		end
	end)
end
function oneArmBanditRankPopView:bandWidget()
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_oab")
	self.ccs_bg:setTitleName(i18n("slot_machine_text_13"))
	GridScrollView = i18n("slot_machine_text_13")
	i18n("slot_machine_text_13")[1] = "Text_des"
	self.Text_des = SoraDGetChildByFullPath(self.Center_Node, i18n("slot_machine_text_13"))
	self.Text_des:setString(i18n("slot_machine_text_14"))
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	GridScrollView = "Node_item"
	;("Node_item")[1] = "scroll_ranks"
	self.scroll = SoraDGetChildByFullPath(self.Center_Node, "Node_item")
	self.scroll = GridScrollView.new(self.scroll)
	_ENV = "Node_item"
	;("Node_item").col = 1
	;("Node_item").left = 6
	;("Node_item").top = 5
	;("Node_item").h = 10
	self.scroll:init("Node_item", 0, handler(self, self.createCell), handler(self, self.updateCell))
	GridScrollView = "Node_item"
	;("Node_item")[1] = "Text_no_record"
	self.Text_no_record = SoraDGetChildByFullPath(self.Center_Node, "Node_item")
	self.Text_no_record:setString(i18n("common_text_1464"))
	self.Text_no_record:setVisible(false)
end
function oneArmBanditRankPopView:initData()
	local rankList = oneArmBanditCtrl:getSlotData().rankList
	self.rankList = rankList
	self.recordTotal = math.min(10, #self.rankList)
	self.scroll:updateNum(self.recordTotal)
	if self.recordTotal > 0 then
		self.Text_no_record:setVisible(false)
	else
		self.Text_no_record:setVisible(true)
	end
end
function oneArmBanditRankPopView:createCell()
	local cell = self:createRecordItem()
	return cell
end
function oneArmBanditRankPopView:updateCell(panel, i)
	local info = self.rankList[i]
	_UPVALUE0_ = nil
	;(nil).index = i
	;(nil).info = info
	panel.initData(nil)
end
function oneArmBanditRankPopView:createRecordItem()
	local item = self.Node_item:clone()
	gametop = nil
	;(nil)[1] = "Image_barBg"
	item.imgBarBg = SoraDGetChildByFullPath(item, nil)
	gametop = nil
	;(nil)[1] = "Text_index"
	item.labIndex = SoraDGetChildByFullPath(item, nil)
	gametop = nil
	;(nil)[1] = "Sprite_index"
	item.sprIndex = SoraDGetChildByFullPath(item, nil)
	gametop = nil
	;(nil)[1] = "Image_head"
	item.imgHead = SoraDGetChildByFullPath(item, nil)
	gametop = nil
	;(nil)[1] = "text_name"
	item.labName = SoraDGetChildByFullPath(item, nil)
	gametop = nil
	;(nil)[1] = "text_time"
	item.labTime = SoraDGetChildByFullPath(item, nil)
	gametop = nil
	;(nil)[1] = "text_gold"
	item.labGold = SoraDGetChildByFullPath(item, nil)
	function item.initData(data)
		if data.index then
			item.index = data.index
			item.labIndex:setString(item.index)
			local labVisible = item.index > RANK_TOP_SPECIAL
			item.labIndex:setVisible(labVisible)
			item.sprIndex:setVisible(not labVisible)
			if item.index <= RANK_TOP_SPECIAL then
				item.sprIndex:setSpriteFrame("icon_ranking_" .. item.index .. ".png")
				item.imgBarBg:loadTexture("frame_alliance_pank_0" .. item.index .. ".png", ccui.TextureResType.plistType)
			else
				item.imgBarBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
			end
		end
		local info = data.info
		if not info then
			return
		end
		item.info = info
		if info.uid and info.uid == gametop.playertop_:getPlayerID() then
			item.labName:setColor(cc.c3b(220, 145, 90))
			item.labTime:setColor(cc.c3b(255, 210, 70))
		else
			item.labName:setColor(cc.c3b(255, 255, 255))
			item.labTime:setColor(cc.c3b(200, 170, 150))
		end
		if info.kid and info.name then
			local suffix
			if info.abbr and info.abbr ~= "" then
				item = cc.c3b(200, 170, 150)
				cc.c3b(200, 170, 150).abbr = info.abbr
				cc.c3b(200, 170, 150).name = info.name
				suffix = i18n("common_text_186", cc.c3b(200, 170, 150))
			else
				suffix = info.name
			end
			local str = string.format("%s#%d", suffix, info.kid)
			item.labName:setString(str)
		end
		if info.gold then
			item.labGold:setString(string.formatnumberthousands(info.gold))
		end
		if info.imageId and info.avatar then
			SoraDGetHeadFromManager(item.imgHead, info.imageId, info.avatar)
		end
		if info.time then
			item.labTime:setString(os.date("%m-%d %H:%M", info.time))
		end
	end
	return item
end
return oneArmBanditRankPopView
