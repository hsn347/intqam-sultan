local instanceFactory = include("instanceFactory")
local worldMapComGroup = class("worldMapComGroup", include("worldMapCom"))
local Z_ORDER = worldMapDefine.Z_ORDER
local GROU_ID = worldMapDefine.GROU_ID
function worldMapComGroup:ctor()
	worldMapComGroup.super.ctor(self, "worldMapComGroup")
end
function worldMapComGroup:init()
	worldMapComGroup.super.init(self)
	self:initGroupNode()
end
function worldMapComGroup:initGroupNode()
	local containerView = self.target_.containerView
	local mapClassType = self.target_.mapClassType
	local createGroupNode = function(groupID, zOrder)
		local node = display.newNode()
		node:setGroupID(groupID, true)
		node:addTo(containerView, zOrder)
		node:setName(string.format("GROUP(%d)", groupID))
	end
	createGroupNode(GROU_ID.build_star_normal, Z_ORDER.objFgView)
	createGroupNode(GROU_ID.build_star_glone, Z_ORDER.objFgView)
	createGroupNode(GROU_ID.build_star_particle, Z_ORDER.objFgView)
	createGroupNode(GROU_ID.group_level_build, Z_ORDER.objLevelBg)
	createGroupNode(GROU_ID.group_name_monster, Z_ORDER.objFgView)
	createGroupNode(GROU_ID.group_level_monster, Z_ORDER.objFgView)
	createGroupNode(GROU_ID.group_progress_monster, Z_ORDER.objFgView)
	createGroupNode(GROU_ID.group_text_monster, Z_ORDER.objFgView)
	createGroupNode(GROU_ID.group_camp_icon, Z_ORDER.objFgView)
	createGroupNode(GROU_ID.group_warLv_top, Z_ORDER.objFgView)
	createGroupNode(GROU_ID.group_warLv_top_particle, Z_ORDER.objFgView)
	createGroupNode(GROU_ID.group_flag, Z_ORDER.objLevelBg)
	createGroupNode(GROU_ID.group_text, Z_ORDER.objFgView)
	createGroupNode(GROU_ID.group_sign, Z_ORDER.objFgView)
	createGroupNode(GROU_ID.group_protect, Z_ORDER.objFgView)
	createGroupNode(GROU_ID.group_protect_new, Z_ORDER.objFgView)
	createGroupNode(GROU_ID.group_moveline_particle, Z_ORDER.moveLineFg)
	createGroupNode(GROU_ID.group_moveline_lodicon, Z_ORDER.moveLineFg)
	createGroupNode(GROU_ID.group_moveline, Z_ORDER.moveLine)
	createGroupNode(GROU_ID.group_moveline_fighting, Z_ORDER.moveLine)
	createGroupNode(GROU_ID.group_moveline_particle_bg, Z_ORDER.moveLine)
	if mapClassType == gKingdomClassType.radiance then
		createGroupNode(GROU_ID.group_moveline_text, Z_ORDER.moveLine)
	end
	createGroupNode(GROU_ID.group_animate_object_bg, Z_ORDER.selectBgView)
	createGroupNode(GROU_ID.group_animate_object_fg, Z_ORDER.scrollView)
	createGroupNode(GROU_ID.group_animate_object_top, Z_ORDER.animateLayerFg)
	createGroupNode(GROU_ID.group_border, Z_ORDER.selectBgView)
	createGroupNode(GROU_ID.group_warLv_base, Z_ORDER.warLvBase)
	createGroupNode(GROU_ID.group_warLv_base_particle, Z_ORDER.warLvBase)
	createGroupNode(GROU_ID.group_particle_bg, Z_ORDER.selectBgView)
	createGroupNode(GROU_ID.group_emoji, Z_ORDER.objFgView)
	createGroupNode(GROU_ID.group_alliance_pet, Z_ORDER.objLevelBg)
	createGroupNode(GROU_ID.tileEffectBatchNode, Z_ORDER.rolygonView)
	createGroupNode(GROU_ID.tileEffectGLONEBatchNode, Z_ORDER.rolygonView)
	include("troopsHelper").initMarchGroupNode(function(groupID)
		createGroupNode(groupID, Z_ORDER.moveLine)
	end)
	createGroupNode(GROU_ID.group_moveline_divinebeast, Z_ORDER.moveLine)
	createGroupNode(GROU_ID.group_alliance_mark, worldMapDefine.Z_ORDER_CELL.objView + 1)
	createGroupNode(instanceFactory.batchNode.castleBatchNode, Z_ORDER.objCastleBgView)
	for _, v in ipairs(worldMapDefine.tableCastleTable) do
		createGroupNode(v, Z_ORDER.objCastleBgView)
	end
	createGroupNode(instanceFactory.batchNode.attackEffectBatchNode, Z_ORDER.objCastleBgView)
	_ENV = createGroupNode
	createGroupNode[1] = instanceFactory.batchNode.buildingBatchNode
	do
		local createGroupNode[2], layer = instanceFactory.batchNode.group_lod_icon, createGroupNode
		local zorder = Z_ORDER.objBgView
		if mapClassType == gKingdomClassType.pyramid then
			layer[#layer + 1] = instanceFactory.batchNode.pyramidBatchNode
		elseif mapClassType == gKingdomClassType.legendLord then
			layer[#layer + 1] = instanceFactory.batchNode.palaceBatchNode
		elseif mapClassType == gKingdomClassType.radiance then
			layer[#layer + 1] = instanceFactory.batchNode.buildRadiance
			layer[#layer + 1] = GROU_ID.group_build_color
			layer[#layer + 1] = GROU_ID.group_build_bg
			layer[#layer + 1] = GROU_ID.group_build_effect
			layer[#layer + 1] = GROU_ID.group_build_light
			layer[#layer + 1] = GROU_ID.group_build_light_et
			zorder = Z_ORDER.objCastleBgView
			createGroupNode(GROU_ID.group_build_gate, Z_ORDER.warLvBase)
		elseif mapClassType == gKingdomClassType.atlantis then
			layer[#layer + 1] = instanceFactory.batchNode.buildRadiance
			layer[#layer + 1] = instanceFactory.batchNode.bossBatchNode
			createGroupNode(GROU_ID.group_instance, Z_ORDER.tmxView)
		elseif mapClassType == gKingdomClassType.nebula then
			layer[#layer + 1] = instanceFactory.batchNode.buildRadiance
			layer[#layer + 1] = instanceFactory.batchNode.monsterBatchNode
			createGroupNode(GROU_ID.group_instance, Z_ORDER.tmxView)
		elseif mapClassType == gKingdomClassType.nebulaEmperor or mapClassType == gKingdomClassType.nebulaAllStar then
			layer[#layer + 1] = instanceFactory.batchNode.buildRadiance
			createGroupNode(GROU_ID.group_instance, Z_ORDER.tmxView)
		elseif mapClassType == gKingdomClassType.roaringFlame then
			layer[#layer + 1] = instanceFactory.batchNode.buildRadiance
			layer[#layer + 1] = instanceFactory.batchNode.monsterBatchNode
			createGroupNode(GROU_ID.group_instance, Z_ORDER.tmxView)
			createGroupNode(GROU_ID.roaring_flame_plot, Z_ORDER.selectBgView)
			createGroupNode(GROU_ID.roaring_flame_line1, Z_ORDER.selectBgView)
			createGroupNode(GROU_ID.roaring_flame_line2, Z_ORDER.selectBgView)
		elseif mapClassType == gKingdomClassType.simulatedDrill then
		elseif mapClassType == gKingdomClassType.garden then
			createGroupNode(GROU_ID.group_instance, Z_ORDER.tmxView)
		else
			layer[#layer + 1] = instanceFactory.batchNode.palaceBatchNode
			layer[#layer + 1] = instanceFactory.batchNode.monsterBatchNode
			layer[#layer + 1] = instanceFactory.batchNode.monsterFiestaBatchNode
			layer[#layer + 1] = instanceFactory.batchNode.bossBatchNode
			layer[#layer + 1] = instanceFactory.batchNode.batteryBatchNode
			layer[#layer + 1] = instanceFactory.batchNode.monsterSeaBatchNode
			layer[#layer + 1] = instanceFactory.batchNode.monsterSemlukBatchNode
			layer[#layer + 1] = instanceFactory.batchNode.feastBatchNode
			layer[#layer + 1] = instanceFactory.batchNode.wrathBeastBatchNode
			layer[#layer + 1] = instanceFactory.batchNode.endlessTrialBatchNode
			layer[#layer + 1] = instanceFactory.batchNode.monsterNebulaBatchNode
		end
		for _, v in ipairs(layer) do
			createGroupNode(v, zorder)
		end
	end
	if self.target_._tmxview:getChildByName("group_animate_tmx_bg") == nil then
		local node = display.newNode()
		node:setName("group_animate_tmx_bg")
		node:setGroupID(GROU_ID.group_animate_tmx_bg, true)
		node:addTo(self.target_._tmxview, 0)
	end
end
return worldMapComGroup
