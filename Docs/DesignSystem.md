### **피그마(Figma) 디자인 시스템 사전 설계서: 오늘의 행복 조각**

**버전:** 1.0
**작성일:** 2025년 6월 26일

이 문서는 '오늘의 행복 조각' 앱의 디자인 일관성과 확장성을 보장하기 위한 핵심 디자인 시스템을 정의합니다.

-----

### **1. 컬러 스타일 (Color Styles)**

피그마에서 `Color Styles`를 생성할 때, `Primary/sunset-500` 과 같이 그룹명/색상명 규칙으로 이름을 지정하면 관리가 매우 용이합니다.

#### **1.1. Primary Colors: Sunset**

*앱의 핵심적인 상호작용(버튼, 강조 등)에 사용되는 주 색상입니다.*
| Figma 스타일 이름 | 라이트 모드 (Hex) | 다크 모드 (Hex) |
| :--- | :--- | :--- |
| `Primary/sunset-50` | `#FFF7F2` | `#4D3A2D` |
| `Primary/sunset-100` | `#FFEFE5` | `#664A38` |
| `Primary/sunset-200` | `#FFD6BB` | `#805C46` |
| `Primary/sunset-300` | `#FFC5A0` | `#996E54` |
| `Primary/sunset-400` | `#FFB994` | `#B38265` |
| **`Primary/sunset-500`** | **`#FFAA7A`** | **`#CC9676`** |
| `Primary/sunset-600` | `#F59562` | `#E6AA8A` |
| `Primary/sunset-700` | `#E07E4C` | `#FFBE9B` |
| `Primary/sunset-800` | `#C26431` | `#FFD2B3` |
| `Primary/sunset-900` | `#A64F1E` | `#FFE7D1` |

#### **1.2. Neutral Colors: Gray**

*앱의 배경, 텍스트, 구분선 등 UI의 뼈대를 이루는 중립적인 색상입니다.*
| Figma 스타일 이름 | 라이트 모드 (Hex) | 다크 모드 (Hex) |
| :--- | :--- | :--- |
| **`Neutral/gray-50`** | **`#F8F7F2`** | **`#1C1C1E`** |
| `Neutral/gray-100` | `#F1F0EB` | `#2C2C2E` |
| `Neutral/gray-200` | `#E8E7E2` | `#3A3A3C` |
| `Neutral/gray-300` | `#D1D1D6` | `#48484A` |
| `Neutral/gray-400` | `#B8B8BE` | `#636366` |
| `Neutral/gray-500` | `#A0A0A8` | `#8E8E93` |
| `Neutral/gray-600` | `#82828B` | `#98989D` |
| `Neutral/gray-700` | `#65656E` | `#C6C6C8` |
| `Neutral/gray-800` | `#4A4A50` | `#D1D1D6` |
| **`Neutral/gray-900`** | **`#3C3C3C`** | **`#F2F2F7`** |

-----

### **2. 텍스트 스타일 (Text Styles)**

피그마에서 `Text Styles`를 생성합니다. `Headline/H1`, `Body/B1-Regular` 와 같은 이름 규칙을 사용합니다. 모든 스타일의 기본 색상은 `Neutral/gray-900`을 적용합니다.

#### **2.1. 기본 UI 글꼴: Pretendard**

| Figma 스타일 이름 | 굵기 (Weight) | 크기 (Size) | 줄 간격 (Line Height) | 용도 |
| :--- | :--- | :--- | :--- | :--- |
| `Headline/H1` | Bold | 28pt | 36pt | 중요한 화면의 제목 |
| `Headline/H2` | Bold | 22pt | 28pt | 섹션 제목 |
| `Headline/H3` | SemiBold | 18pt | 24pt | 카드, 리스트 제목 |
| `Body/B1-Regular` | Regular | 16pt | 24pt | 가장 일반적인 본문 |
| `Body/B1-Bold` | Bold | 16pt | 24pt | 강조가 필요한 본문, 버튼 |
| `Body/B2-Regular` | Regular | 14pt | 20pt | 보조적인 설명 텍스트 |
| `Caption/C1` | Regular | 12pt | 16pt | 아이콘 라벨, 가장 작은 텍스트 |

#### **2.2. 감성 포인트 글꼴 (사용자 선택 가능)**

| Figma 스타일 이름 | 기본 글꼴 | 굵기 (Weight) | 크기 (Size) | 줄 간격 (Line Height) | 용도 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `Note/Title` | Gaegu | Bold | 20pt | 28pt | 메모 제목 |
| `Note/Body` | Gaegu | Regular | 16pt | 26pt | 메모 본문 |

*위 `Note` 스타일을 기준으로, 사용자가 폰트를 `나눔손글씨 펜`, `Gmarket Sans` 등으로 변경할 수 있도록 시스템을 구상합니다.*

-----

### **3. 레이아웃 및 그리드 시스템 (Layout & Grid System)**

모든 디자인은 **8pt 그리드 시스템**을 기반으로 합니다. 모든 간격(Spacing)과 여백(Padding)은 8의 배수를 사용합니다.

  * **기본 화면 여백 (Screen Padding):** 좌우 20pt
  * **간격 단위 (Spacing Unit):**
      * `4pt` (micro)
      * `8pt` (xx-small)
      * `12pt` (x-small)
      * `16pt` (small) - **가장 흔하게 사용되는 간격**
      * `24pt` (medium)
      * `32pt` (large)
      * `40pt` (x-large)

-----

### **4. 컴포넌트 명세서 (Component Specification)**

가장 기본이 되는 버튼 컴포넌트부터 정의합니다. 피그마의 **Variants** 기능을 사용하여 `Style`, `Size`, `State`를 속성으로 만듭니다.
네, 물론입니다. 버튼 컴포넌트의 나머지 상세 명세를 이어서 작성해 드리겠습니다.

앞서 정의한 **Primary / Large** 스타일에 이어, **Primary / Medium**, 그리고 보조적인 역할을 하는 **Secondary** 스타일 버튼의 명세를 추가하겠습니다. 이 명세는 피그마의 Variants 기능을 활용하여 하나의 강력한 버튼 컴포넌트를 만드는 데 사용됩니다.

---

### **4. 컴포넌트 명세서 (Component Specification)** (계속)

#### **4.1. 버튼 (Button)**

**[속성 (Properties)]**
* **Style:** `Primary`, `Secondary`, `Tertiary` (추가 제안)
* **Size:** `Large`, `Medium`
* **State:** `Enabled`, `Pressed`, `Disabled`

---

#### **Primary Button (주요 버튼)**
* **설명:** 앱 내에서 가장 중요한 액션을 수행할 때 사용하는 버튼입니다. 사용자의 시선을 가장 먼저 끌어야 합니다.
* **디자인:** 채워진 배경색(Solid)을 사용하여 강하게 주목시킵니다.

**[Primary / Large 버튼 명세]**
| 속성 (Attribute) | 값 (Value) |
| :--- | :--- |
| **Height** | 52pt |
| **Padding** | 좌우 24pt |
| **Corner Radius** | 26pt |
| **Text Style** | `Body/B1-Bold` |
| **Enabled (기본)** | 배경: `Primary/sunset-500` / 텍스트: `#FFFFFF` |
| **Pressed (클릭 시)** | 배경: `Primary/sunset-600` / 텍스트: `#FFFFFF` |
| **Disabled (비활성)** | 배경: `Neutral/gray-200` / 텍스트: `Neutral/gray-500` |

**[Primary / Medium 버튼 명세]**
| 속성 (Attribute) | 값 (Value) |
| :--- | :--- |
| **Height** | 44pt |
| **Padding** | 좌우 20pt |
| **Corner Radius** | 22pt |
| **Text Style** | `Body/B1-Bold` |
| **Enabled (기본)** | 배경: `Primary/sunset-500` / 텍스트: `#FFFFFF` |
| **Pressed (클릭 시)** | 배경: `Primary/sunset-600` / 텍스트: `#FFFFFF` |
| **Disabled (비활성)** | 배경: `Neutral/gray-200` / 텍스트: `Neutral/gray-500` |

---

#### **Secondary Button (보조 버튼)**
* **설명:** Primary 버튼보다는 중요도가 낮지만, 여전히 주요 액션 중 하나일 때 사용합니다. (예: '취소' 옆의 '임시 저장')
* **디자인:** 외곽선(Outline) 스타일을 사용하여 Primary 버튼을 방해하지 않으면서도 명확한 액션을 나타냅니다.

**[Secondary / Large 버튼 명세]**
| 속성 (Attribute) | 값 (Value) |
| :--- | :--- |
| **Height** | 52pt |
| **Padding** | 좌우 24pt |
| **Corner Radius** | 26pt |
| **Text Style** | `Body/B1-Bold` |
| **Border** | 1.5pt |
| **Enabled (기본)** | 배경: `Transparent` / 텍스트: `Primary/sunset-500` / 테두리: `Primary/sunset-500` |
| **Pressed (클릭 시)** | 배경: `Primary/sunset-50` / 텍스트: `Primary/sunset-500` / 테두리: `Primary/sunset-500` |
| **Disabled (비활성)** | 배경: `Transparent` / 텍스트: `Neutral/gray-300` / 테두리: `Neutral/gray-300` |

**[Secondary / Medium 버튼 명세]**
| 속성 (Attribute) | 값 (Value) |
| :--- | :--- |
| **Height** | 44pt |
| **Padding** | 좌우 20pt |
| **Corner Radius** | 22pt |
| **Text Style** | `Body/B1-Bold` |
| **Border** | 1.5pt |
| **Enabled (기본)** | 배경: `Transparent` / 텍스트: `Primary/sunset-500` / 테두리: `Primary/sunset-500` |
| **Pressed (클릭 시)** | 배경: `Primary/sunset-50` / 텍스트: `Primary/sunset-500` / 테두리: `Primary/sunset-500` |
| **Disabled (비활성)** | 배경: `Transparent` / 텍스트: `Neutral/gray-300` / 테두리: `Neutral/gray-300` |

---

#### **Tertiary Button (텍스트 버튼) - 추가 제안**
* **설명:** 가장 낮은 단계의 액션에 사용합니다. (예: '닫기', '자세히 보기', '취소')
* **디자인:** 배경과 테두리가 없는 텍스트 형태로, 주변 UI를 해치지 않고 간결하게 액션을 제공합니다.

**[Tertiary 버튼 명세]**
| 속성 (Attribute) | 값 (Value) |
| :--- | :--- |
| **Height** | 콘텐츠 크기에 맞춤 (Hug Contents) |
| **Padding** | 없음 (필요시 추가) |
| **Text Style** | `Body/B1-Bold` 또는 `Body/B2-Regular` (맥락에 따라 선택) |
| **Enabled (기본)** | 텍스트: `Primary/sunset-500` |
| **Pressed (클릭 시)** | 텍스트: `Primary/sunset-600` |
| **Disabled (비활성)**| 텍스트: `Neutral/gray-300` |

---

이것으로 '오늘의 행복 조각' 앱에서 사용될 핵심 버튼 컴포넌트 시스템의 명세가 모두 완성되었습니다.

이 설계서를 기반으로 피그마에서 컴포넌트를 제작하시면, 어떤 화면에서든 일관된 디자인의 버튼을 빠르고 쉽게 사용하실 수 있습니다.

다음으로 **입력창(Input Field)**이나 **카드(Card)** 같은 다른 컴포넌트의 명세가 필요하시면 언제든지 말씀해주세요.