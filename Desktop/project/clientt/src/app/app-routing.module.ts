  import { NgModule } from '@angular/core';
  import { RouterModule, Routes } from '@angular/router';
  import {HomeComponent} from "./component/home/home.component";
  import {LoginComponent} from "./component/login/login.component";
  import {DefaultComponent} from "./default/default/default.component";
  import {RegisterComponent} from "./component/register/register.component";

  import {AppartementComponent} from "./component/add/appartement/appartement.component";
  import {AuthGuard} from "./guard/auth.guard";
  import {LogementComponent} from "./component/logement/logement.component";
  import {UserComponent} from "./component/user/user/user.component";
  import {ProfileComponent} from "./component/profile/profile.component";
  import {DetailProprietaireComponent} from "./component/detail-proprietaire/detail-proprietaire.component";
  import {EditUserComponent} from "./component/edit-user/edit-user.component";

  const routes: Routes = [
    { path: 'login', component: LoginComponent },
    {
      path: '',
      component: DefaultComponent,
      canActivate: [AuthGuard],
      children: [
        { path: '', component: HomeComponent },
        { path: 'addAppartement', component: AppartementComponent },
        { path: 'liste-appartement', component: LogementComponent },
        { path: 'proprietaire', component: UserComponent },
        { path: 'profile', component: ProfileComponent },
        { path: 'register', component: RegisterComponent },
        { path: 'detail/:id', component: DetailProprietaireComponent },
        { path: 'edit-user/:id', component: EditUserComponent },
      ]
    },
  //  { path: '**', redirectTo: '/login' },  // Redirect any unknown paths to login
  ];
  @NgModule({
    imports: [RouterModule.forRoot(routes)],
    exports: [RouterModule]
  })
  export class AppRoutingModule { }
