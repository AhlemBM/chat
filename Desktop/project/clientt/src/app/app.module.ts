import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

import { LoginComponent } from './component/login/login.component';

import { RegisterComponent } from './component/register/register.component';
import { HomeComponent } from './component/home/home.component';
import {SharedModule} from "./shared/shared.module";
import {DefaultModule} from "./default/default.module";
import { CalenderComponent } from './component/calender/calender.component';
import { LogementComponent } from './component/logement/logement.component';
import { PayComponent } from './component/pay/pay.component';
import { FactureComponent } from './component/facture/facture.component';
import { ReservationComponent } from './component/reservation/reservation.component';
import {HttpClientModule} from "@angular/common/http";
import {Axios} from "axios";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import { UserComponent } from './component/user/user/user.component';

import { AppartementComponent } from './component/add/appartement/appartement.component';
import {AuthGuard} from "./guard/auth.guard";
import {AppartementService} from "./services/appartementService/appartement.service";
import {UserService} from "./services/user/user.service";
import { ProfileComponent } from './component/profile/profile.component';
import {RouterModule, Routes} from "@angular/router";
import { DetailProprietaireComponent } from './component/detail-proprietaire/detail-proprietaire.component';
import { EditUserComponent } from './component/edit-user/edit-user.component';
import {CommonModule} from "@angular/common";

const routes: Routes = [
  { path: 'profile', component: ProfileComponent },
  // Autres routes ici
];



@NgModule({
  declarations: [
    AppComponent,

    LoginComponent,

    RegisterComponent,
    HomeComponent,
    CalenderComponent,
    LogementComponent,
    PayComponent,
    FactureComponent,
    ReservationComponent,
    UserComponent,

    AppartementComponent,
    ProfileComponent,
    DetailProprietaireComponent,
    EditUserComponent,

  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    SharedModule,
    DefaultModule,
    HttpClientModule,
    FormsModule,
    RouterModule.forRoot(routes),
    ReactiveFormsModule,
    CommonModule,// Ajoutez cette ligne

  ],
  providers: [ AuthGuard, AppartementService, UserService],
  bootstrap: [AppComponent]
})
export class AppModule { }
