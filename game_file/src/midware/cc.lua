if not CS.Sultan.Middleware then
	_ENV = CS.Sultan.Middleware
end
cc = CS.Sultan.Middleware
if not CS.Sultan.Game then
	_ENV = CS.Sultan.Game
end
ccexp = CS.Sultan.Game
print("cc=======================", cc)
cc.bPlugin_ = true
BgAssetsManager = cc.BgAssetsManager
cc.EventListenerAcceleration = require("midware.cocos2d.Event.EventListenerAcceleration")
cc.EventListenerTouchOneByOne = require("midware.cocos2d.Event.EventListenerAssetsManagerEx")
cc.EventListenerCustom = require("midware.cocos2d.Event.EventListenerCustom")
cc.EventListenerKeyboard = require("midware.cocos2d.Event.EventListenerKeyboard")
cc.EventListenerMouse = require("midware.cocos2d.Event.EventListenerMouse")
cc.EventListenerTouchOneByOne = require("midware.cocos2d.Event.EventListenerTouchOneByOne")
cc.Device = require("midware.cocos2d.Device")
cc.Scheduler = require("midware.cocos2d.Scheduler")
cc.GLNode = require("midware.cocos2d.GLNode")
cc.Sprite3D = require("midware.cocos2d.Sprite3D")
cc.Prefab = CS.Sultan.Middleware.CCPrefab
cc.Animation3D = require("midware.cocos2d.Animation3D")
cc.Sprite = require("midware.baseComponent.BaseSprite")
cc.Label = require("midware.baseComponent.BaseText")
cc.ParticleSystemQuad = require("midware.cocos2d.ParticleSystemQuad")
cc.NodeGrid = require("midware.cocos2d.NodeGrid")
cc.Layer = require("midware.cocos2d.Layer")
cc.LayerColor = require("midware.cocos2d.LayerColor")
cc.LayerGradient = require("midware.cocos2d.LayerGradient")
cc.Scene = require("midware.cocos2d.Scene")
cc.AnimationCache = require("midware.cocos2d.AnimationCache")
cc.DrawNode1 = require("midware.cocos2d.DrawNode1")
_ENV = require("midware.cocos2d.DrawNode1")
cc.Image, require("midware.cocos2d.DrawNode1").setPVRImagesHavePremultipliedAlpha = require("midware.cocos2d.DrawNode1"), function(bValue)
end
cc.CSLoader = require("midware.cocos2d.CSLoader")
cc.ProgressTimer = require("midware.baseComponent.BaseProgressBar")
cc.ScrollView = require("midware.baseComponent.CCScrollView")
cc.MeshNode = require("midware.cocos2d.MeshNode")
cc.RenderTexture = require("midware.cocos2d.RenderTexture")
cc.criSprite = require("midware.criWare.criSprite")
cc.criAdx = require("midware.criWare.criAdx")
cc.GLProgram = require("midware.cocos2d.GLProgram")
cc.GLProgramState = require("midware.cocos2d.GLProgramState")
cc.GLProgramCache = require("midware.cocos2d.GLProgramCache")
cc.PhysicsBody = cc.Physics.PhysicsBody
cc.TSPhysicsBody = cc.TSPhysics.PhysicsBody
cc.size = require("midware.cocos2d.struct.Size")
cc.rect = cc.ccRect
if not cc.ui then
	_ENV = cc.ui
end
cc.ui = cc.ui
cc.ui.UILabel = require("midware.baseComponent.BaseText")
cc.ui.PushButton = fgui.GButton
require("midware.cocos2d.extension.NodeEx")
require("midware.cocos2d.extension.DirectorEx")
require("midware.cocos2d.extension.ActionManagerEx")
require("midware.cocos2d.extension.SpriteFrameEx")
require("midware.cocos2d.extension.action.BezierToEx")
require("midware.baseComponent.BaseParticle")
PlistDataManager = require("midware.cocos2d.PlistDataManager")
SysFontLabelSprite = require("midware.baseComponent.BaseText")
SysFontLabelSpriteNoChild = require("midware.baseComponent.BaseTextNoChild")
SpriteBatchNodeEx = cc.Node
cc.VERTICAL_TEXT_ALIGNMENT_MIDDLE = 1
cc.kCCHTTPRequestMethodGET = 0
cc.kCCHTTPRequestMethodPOST = 1
ccexp.WebView = require("midware.cocos2d.UIWebView")
cc.HTTPRequest = cc.HTTPRequestUnity
