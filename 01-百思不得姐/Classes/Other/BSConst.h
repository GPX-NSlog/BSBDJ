

#import <UIKit/UIKit.h>


typedef enum {
    BSTopicTypeAll = 1,
    BSTopicTypePicture = 10,
    BSTopicTypeWord = 29,
    BSTopicTypeVoice = 31,
    BSTopicTypeVideo = 41,
    
}BSTopicType;

UIKIT_EXTERN CGFloat const BSTitilesViewH;
UIKIT_EXTERN CGFloat const BSTitilesViewY;

/** 精华-cell-间距 */
UIKIT_EXTERN CGFloat const BSTopicCellMargin;
/** 精华-cell-文字内容的Y值 */
UIKIT_EXTERN CGFloat const BSTopicCellTextY;
/** 精华-cell-底部工具条的高度 */
UIKIT_EXTERN CGFloat const BSTopicCellBottomBarH;
/** 图片的最大高度 */
UIKIT_EXTERN CGFloat const BSTopicCellPictureMaxH;
/** 图片的要显示的高度 */
UIKIT_EXTERN CGFloat const BSTopicCellPictureMaxShowH;

/** XMGUser模型-性别属性值 */
UIKIT_EXTERN NSString * const BSUserSexMale;
UIKIT_EXTERN NSString * const BSUserSexFemale;

/** 精华-cell-最热评论标题的高度 */
UIKIT_EXTERN CGFloat const BSTopicCellTopCmtTitleH;

