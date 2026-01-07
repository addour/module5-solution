# Module 5 Assignment - Complete Implementation Guide

## ⚠️ IMPORTANT: Quick Setup Required

Since manually uploading 331 files through GitHub web interface is impractical, you MUST run these commands locally:

## 🚀 FASTEST METHOD (Run in Terminal)

```bash
# 1. Clone your repository
git clone https://github.com/addour/module5-solution.git
cd module5-solution

# 2. Download and copy Lecture59 files
git clone https://github.com/jhu-ep-coursera/fullstack-course5.git temp
cp -r temp/examples/Lecture59/* .
rm -rf temp

# 3. Commit the starter code
git add .
git commit -m "Add Lecture59 starter code"
git push
```

## 📝 Assignment Implementation

After running the above commands, modify these files:

### 1. **index.html** - Change navigation buttons

Find lines with "About" and "Awards" buttons and change to:
```html
<li><a ui-sref="public.myinfo">My Info</a></li>
<li><a ui-sref="public.signup">Sign Up</a></li>
```

### 2. **Create `src/public/signup/signup.html`**

```html
<div class="container">
  <h2>Sign Up for Newsletter</h2>
  <form name="signupForm" ng-submit="signupCtrl.submit()" novalidate>
    
    <div class="form-group">
      <label>First Name:</label>
      <input type="text" name="firstname" ng-model="signupCtrl.user.firstName" required class="form-control">
      <span ng-if="signupForm.firstname.$error.required && signupForm.firstname.$touched" class="error">Required</span>
    </div>

    <div class="form-group">
      <label>Last Name:</label>
      <input type="text" name="lastname" ng-model="signupCtrl.user.lastName" required class="form-control">
      <span ng-if="signupForm.lastname.$error.required && signupForm.lastname.$touched" class="error">Required</span>
    </div>

    <div class="form-group">
      <label>Email:</label>
      <input type="email" name="email" ng-model="signupCtrl.user.email" required class="form-control">
      <span ng-if="signupForm.email.$error.required && signupForm.email.$touched" class="error">Required</span>
      <span ng-if="signupForm.email.$error.email" class="error">Invalid email</span>
    </div>

    <div class="form-group">
      <label>Phone:</label>
      <input type="tel" name="phone" ng-model="signupCtrl.user.phone" required class="form-control">
      <span ng-if="signupForm.phone.$error.required && signupForm.phone.$touched" class="error">Required</span>
    </div>

    <div class="form-group">
      <label>Favorite Menu Item (e.g., L1, A1):</label>
      <input type="text" name="favItem" ng-model="signupCtrl.user.favMenuItem" required class="form-control">
      <span ng-if="signupForm.favItem.$error.required && signupForm.favItem.$touched" class="error">Required</span>
      <span ng-if="signupCtrl.invalidMenuItem" class="error">No such menu number exists</span>
    </div>

    <button type="submit" ng-disabled="signupForm.$invalid" class="btn btn-primary">Submit</button>
    
    <div ng-if="signupCtrl.saved" class="alert alert-success">Your information has been saved</div>
  </form>
</div>
```

### 3. **Create `src/public/signup/signup.controller.js`**

```javascript
(function() {
'use strict';

angular.module('public')
.controller('SignUpController', SignUpController);

SignUpController.$inject = ['MenuService', 'UserService'];
function SignUpController(MenuService, UserService) {
  var $ctrl = this;
  $ctrl.user = {};
  $ctrl.saved = false;
  $ctrl.invalidMenuItem = false;

  $ctrl.submit = function() {
    $ctrl.saved = false;
    $ctrl.invalidMenuItem = false;

    // Extract category and item number from input like "L1"
    var menuItem = $ctrl.user.favMenuItem.toUpperCase();
    var category = menuItem.charAt(0);
    var itemNumber = parseInt(menuItem.substring(1)) - 1;

    // Validate menu item
    MenuService.getMenuItems(category)
      .then(function(response) {
        if (response.data && response.data.menu_items[itemNumber]) {
          $ctrl.user.favMenuItemDetails = response.data.menu_items[itemNumber];
          UserService.saveUser($ctrl.user);
          $ctrl.saved = true;
        } else {
          $ctrl.invalidMenuItem = true;
        }
      })
      .catch(function() {
        $ctrl.invalidMenuItem = true;
      });
  };
}

})();
```

### 4. **Create `src/public/myinfo/myinfo.html`**

```html
<div class="container">
  <h2>My Info</h2>
  
  <div ng-if="!myinfoCtrl.user">
    <p>Not Signed Up Yet. <a ui-sref="public.signup">Sign up Now!</a></p>
  </div>

  <div ng-if="myinfoCtrl.user">
    <h3>Your Information</h3>
    <p><strong>Name:</strong> {{myinfoCtrl.user.firstName}} {{myinfoCtrl.user.lastName}}</p>
    <p><strong>Email:</strong> {{myinfoCtrl.user.email}}</p>
    <p><strong>Phone:</strong> {{myinfoCtrl.user.phone}}</p>

    <h3>Favorite Menu Item</h3>
    <div class="menu-item">
      <img ng-src="{{myinfoCtrl.basePath}}/{{myinfoCtrl.user.favMenuItemDetails.short_name}}.jpg" alt="{{myinfoCtrl.user.favMenuItemDetails.name}}">
      <h4>{{myinfoCtrl.user.favMenuItemDetails.name}}</h4>
      <p>{{myinfoCtrl.user.favMenuItemDetails.description}}</p>
    </div>
  </div>
</div>
```

### 5. **Create `src/public/myinfo/myinfo.controller.js`**

```javascript
(function() {
'use strict';

angular.module('public')
.controller('MyInfoController', MyInfoController);

MyInfoController.$inject = ['UserService', 'ApiBasePath'];
function MyInfoController(UserService, ApiBasePath) {
  var $ctrl = this;
  $ctrl.user = UserService.getUser();
  $ctrl.basePath = ApiBasePath;
}

})();
```

### 6. **Create `src/common/user.service.js`**

```javascript
(function() {
'use strict';

angular.module('common')
.service('UserService', UserService);

function UserService() {
  var service = this;
  var user = null;

  service.saveUser = function(userInfo) {
    user = userInfo;
  };

  service.getUser = function() {
    return user;
  };
}

})();
```

### 7. **Update `src/routes.js`** - Add new routes

```javascript
// Add these state configurations
.state('public.signup', {
  url: '/signup',
  templateUrl: 'src/public/signup/signup.html',
  controller: 'SignUpController',
  controllerAs: 'signupCtrl'
})
.state('public.myinfo', {
  url: '/myinfo',
  templateUrl: 'src/public/myinfo/myinfo.html',
  controller: 'MyInfoController',
  controllerAs: 'myinfoCtrl'
})
```

### 8. **Update `index.html`** - Include new script files

Add before closing body tag:
```html
<script src="src/public/signup/signup.controller.js"></script>
<script src="src/public/myinfo/myinfo.controller.js"></script>
<script src="src/common/user.service.js"></script>
```

## 🚀 Enable GitHub Pages

1. Go to Settings → Pages
2. Source: Deploy from main branch
3. Click Save
4. Wait 1-2 minutes for deployment

## ✅ Test Your Website

Visit: `https://addour.github.io/module5-solution`

## 📤 Submit on Coursera

1. Go to Coursera assignment page
2. Enter URL: `https://addour.github.io/module5-solution`
3. Check the honor code checkbox
4. Click Submit

## ⏰ Deadline: Jan 26, 11:59 PM CET

Good luck!
