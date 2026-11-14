local _isNewEngine = false
if _G.vec2_isLineIntersect then
	_isNewEngine = true
end
function isNewEngine()
	return _isNewEngine
end
require("cocos.cocos2d.Cocos2d")
require("cocos.cocos2d.Cocos2dConstants")
require("cocos.cocos2d.extern")
require("cocos.cocos2d.bitExtend")
require("cocos.cocos2d.DrawPrimitives")
require("cocos.cocos2d.Opengl")
require("cocos.cocos2d.OpenglConstants")
require("cocos.cocosbuilder.CCBReaderLoad")
require("cocos.cocosdenshion.AudioEngine")
if nil ~= ccs then
	require("cocos.cocostudio.CocoStudio")
end
if nil ~= ccui then
	require("cocos.ui.GuiConstants")
	require("cocos.ui.experimentalUIConstants")
end
require("cocos.extension.ExtensionConstants")
require("cocos.network.NetworkConstants")
if nil ~= sp then
	require("cocos.spine.SpineConstants")
end
if cc.Physics3DComponent then
	require("cocos.physics3d.physics3d-constants")
end
require("cocos.cocos2d.deprecated")
if CC_USE_DEPRECATED_API then
	require("cocos.cocos2d.DeprecatedCocos2dClass")
	require("cocos.cocos2d.DeprecatedCocos2dEnum")
	require("cocos.cocos2d.DeprecatedCocos2dFunc")
	require("cocos.cocos2d.DeprecatedOpenglEnum")
	if nil ~= ccs then
		require("cocos.cocostudio.DeprecatedCocoStudioClass")
		require("cocos.cocostudio.DeprecatedCocoStudioFunc")
	end
	require("cocos.cocosbuilder.DeprecatedCocosBuilderClass")
	require("cocos.cocosdenshion.DeprecatedCocosDenshionClass")
	require("cocos.cocosdenshion.DeprecatedCocosDenshionFunc")
	require("cocos.extension.DeprecatedExtensionClass")
	require("cocos.extension.DeprecatedExtensionEnum")
	require("cocos.extension.DeprecatedExtensionFunc")
	require("cocos.network.DeprecatedNetworkClass")
	require("cocos.network.DeprecatedNetworkEnum")
	require("cocos.network.DeprecatedNetworkFunc")
	if nil ~= ccui then
		require("cocos.ui.DeprecatedUIEnum")
		require("cocos.ui.DeprecatedUIFunc")
	end
end
